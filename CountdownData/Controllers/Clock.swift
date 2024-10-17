//
//  Clock.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/19/23.
//

import Foundation
import UserNotifications
import SwiftData
import SwiftUI
import WidgetKit

@Observable
public final class Clock {
    
    // whether this is active mode
    public private(set) var isActive: Bool = false
    
    // whether all data has loaded
    public private(set) var isLoaded: Bool = false
    
    // countdowns source of truth
    public private(set) var countdowns: [Countdown] = []
    
    // selected countdown reference
    public private(set) var selectedCountdown: Countdown?
    
    // tick update boolean
    public private(set) var tick: Bool = false
    
    // tick updates enabled
    private var tickUpdatesEnabled: Bool = true
    
    // standard delay constant
    public let delay: Double = 0.35
    
    // scheduled timer
    private var timer: Timer?
    
    // countdown id to select after fetching
    private var fetchID: UUID?
    
    // model context from environment
    private var modelContext: ModelContext
    
    // init from model context
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // notifications enabled setting
    @AppStorage("notifications") public static var notifications: Bool = true
    
    
    // MARK: - Active Mode Setup
    // Used for the main app interface
    // Content is loaded and updated throughout the app lifecycle
    // - loaded on startup and any subsequent view state transitions
    // - can also be force refreshed
    
    // Load all data when the view appears
    // Set counters and start clock
    public func didBecomeActive() {
        guard !isActive else { return }
        isActive = true
        fetchData()
        resetWidgets()
        Task {
            await loadCards()
            await scheduleNotifications()
            synchronize()
            await start()
        }
    }
    
    // Stop the clock when the view enters the background
    public func didEnterBackground() {
        guard isActive else { return }
        isActive = false
        resetWidgets()
        Task {
            await scheduleNotifications()
        }
        stop()
    }
    
    // Stop the clock when the view disappears
    public func didBecomeInactive() {
        guard isActive else { return }
        isActive = false
        resetWidgets()
        Task {
            await scheduleNotifications()
        }
        stop()
    }
    
    // Reset data and clock after force refresh
    public func refresh() async {
        stop()
        fetchData()
        await loadCards()
        synchronize()
        await start()
    }
    
    // Pause/Resume tick updates
    // Pausing means view will not force updated on tick
    // This is useful during gestures, for example
    public func pauseTickUpdates() {
        tickUpdatesEnabled = false
    }
    public func resumeTickUpdates() {
        tickUpdatesEnabled = true
    }
    
    
    // MARK: - Static Mode Setup
    // Used for widgets and messages
    // Content is loaded a single time (potentially with predicate)
    // Counters are set but no clock is started
    
    // Load specified countdown(s) data after fetching
    public func loadStaticCountdownData(predicate: Predicate<Countdown>? = nil, includeCards: Bool = true) async {
        fetchData(predicate: predicate)
        if includeCards {
            await loadCards()
        }
        synchronize()
    }
    
    
    // MARK: - Public Intents
    // Add and delete countdowns and make necessary changes
    
    // Select countdown
    public func select(_ countdown: Countdown?) {
        selectedCountdown = countdown
    }
    
    // Select countdown via id
    public func select(_ id: UUID) {
        if let countdown = countdowns.first(where: { $0.id == id }) {
            selectedCountdown = countdown
        } else {
            // if not available, set id to select after fetching
            fetchID = id
        }
    }
    
    // Add countdown
    public func add(_ countdown: Countdown) {
        countdowns.append(countdown)
        modelContext.insert(countdown)
        try? modelContext.save()
        if isActive {
            Task {
                stop()
                await scheduleNotifications()
                synchronize()
                await start()
            }
        }
    }
    
    // Edit countdown
    public func edit(_ countdown: Countdown) {
        try? modelContext.save()
        if isActive {
            Task {
                stop()
                await scheduleNotifications()
                synchronize()
                await start()
            }
        }
    }
    
    // Delete countdown
    public func delete(_ countdown: Countdown) {
        countdowns.removeAll(where: { $0 == countdown })
        modelContext.delete(countdown)
        try? modelContext.save()
    }
    
    
    // MARK: - Private Helpers
    // Internally modify countdowns and clock

    // Fetch data from environment context
    private func fetchData(predicate: Predicate<Countdown>? = nil) {
        do {
            let descriptor = FetchDescriptor<Countdown>(predicate: predicate)
            let countdowns = try modelContext.fetch(descriptor)
            
            // check if there are any differences between the fetched countdowns and stored countdowns
            // if so, we need to modify the stored countdowns array
            // (note: this works b/c if the clock was just initialized, there will be no stored countdowns yet)
            let allCountdownsMatch =
                countdowns.allSatisfy { newCountdown in
                    if let oldCountdown = self.countdowns.first(where: { $0 == newCountdown }) {
                        return oldCountdown.compareTo(countdown: newCountdown)
                    } else {
                        return false
                    }
                } &&
                self.countdowns.allSatisfy { oldCountdown in
                    countdowns.contains(oldCountdown)
                }
            
            // (re)populate the stored countdowns if necessary
            if !allCountdownsMatch {
                self.countdowns = countdowns
                self.isLoaded = false
            }
            
            // select countdown after fetching
            if let fetchID, let countdown = countdowns.first(where: { $0.id == fetchID }) {
                selectedCountdown = countdown
                self.fetchID = nil
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    // Asynchronously load cards for display
    // Transforms backgrounds from raw data to image format
    private func loadCards() async {
        for countdown in countdowns {
            await countdown.loadCards()
        }
    }
    
    // Reload widget timelines
    // Forces all widgets to update their views
    private func resetWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // Schedule notifications for all countdowns
    // Removes all pending notifications and replaces with new ones
    private func scheduleNotifications() async {
        
        // remove all notifications currently pending
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
        // make sure notification setting is enabled to continue
        guard Self.notifications else { return }
        
        do {
            // request notification access if not granted
            guard try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) else {
                print("No access to schedule notifications")
                return
            }
            
            // schedule new notifications
            for countdown in countdowns.filter(\.isActive) {
                guard let components = countdown.occasion.components else { continue }
                
                let content = UNMutableNotificationContent()
                content.title = countdown.displayName
                content.body = "It's time for \(countdown.displayName)!"
                content.sound = UNNotificationSound.default
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: trigger)

                try await UNUserNotificationCenter.current().add(request)
                
                print("Notification set for \(countdown.name)")
            }
        } catch {
            print(error)
        }
    }
    
    // Synchronize the countdown counters
    // Sets clock to current time before ticking timer takes over
    private func synchronize() {
        for countdown in countdowns {
            countdown.timeRemaining = countdown.date.timeRemaining()
            countdown.daysRemaining = countdown.date.daysRemaining()
        }
    }
    
    // Tick
    
    // Start the clock
    private func start() async {
        self.tickUpdatesEnabled = true
        
        // initial tick for setup
        self.tick.toggle()
        
        // a short delay to start the clock when the next realtime second ticks
        let initialDelay: Double = 1 - Double(Date.now.component(.nanosecond))/1E9
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            self.timer?.invalidate()
            
            // tick exactly on the second
            self.tick.toggle()
            for countdown in self.countdowns {
                countdown.tick()
            }
            
            // repeatedly tick every second after this
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.tickUpdatesEnabled {
                    self.tick.toggle()
                }
                for countdown in self.countdowns {
                    countdown.tick()
                }
            }
        }
        
        // now setup is done
        isLoaded = true
    }
    
    // Stop the clock
    private func stop() {
        timer?.invalidate()
    }
    
    
    // MARK: - Other
    
    // Open a URL requesting a specific countdown
    public func link(from url: URL) -> UUID? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.scheme == "countdown",
              components.host == "open",
              let queryItems = components.queryItems,
              let idItem = queryItems.first(where: { $0.name == "id" }),
              let idString = idItem.value,
              let id = UUID(uuidString: idString)
        else {
            return nil
        }
        return id
    }
    
}
