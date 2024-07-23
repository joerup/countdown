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
    
    // notifications enabled setting
    @AppStorage("notifications") public static var notifications: Bool = true
    
    // whether all data has loaded
    public private(set) var isLoaded: Bool = false
    
    // countdowns source of truth
    public private(set) var countdowns: [Countdown] = []
    
    // tick update boolean
    public private(set) var tick: Bool = false
    
    // standard delay constant
    public let delay: Double = 0.35
    
    // scheduled timer
    private var timer: Timer?
    
    // model context from environment
    private var modelContext: ModelContext
    
    // init from model context
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    
    // MARK: - Active Mode Setup
    // Used for the main app interface
    // Content is loaded and updated throughout the app lifecycle
    // - loaded on startup and any subsequent view state transitions
    // - can also be force refreshed
    
    // Load all data when the view appears
    // Set counters and start clock
    public func didBecomeActive() {
        fetchData()
        WidgetCenter.shared.reloadAllTimelines()
        Task {
            await loadCards()
            setCounters()
            await start()
        }
    }
    
    // Stop the clock when the view disappears
    public func didEnterBackground() {
        WidgetCenter.shared.reloadAllTimelines()
        stop()
    }
    
    // Reset data and clock after force refresh
    public func refresh() async {
        stop()
        fetchData()
        await loadCards()
        setCounters()
        await start()
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
        setCounters()
    }
    
    
    // MARK: - Configuration

    // Fetch data from environment context
    private func fetchData(predicate: Predicate<Countdown>? = nil) {
        do {
            let descriptor = FetchDescriptor<Countdown>(predicate: predicate)
            let countdowns = try modelContext.fetch(descriptor)
            if countdowns.contains(where: { countdown in self.countdowns.first(where: { $0 == countdown })?.compareTo(countdown: countdown) != true }) { // reload if countdowns has changed
                self.countdowns = countdowns
                self.isLoaded = false
            }
        } catch {
            print("Fetch failed")
        }
    }
    
    // Asynchronously load cards
    private func loadCards() async {
        for countdown in countdowns {
            await countdown.loadCards()
        }
    }
    
    // Set the counters
    private func setCounters() {
        for countdown in countdowns {
            countdown.timeRemaining = countdown.date.timeRemaining()
            countdown.daysRemaining = countdown.date.daysRemaining()
        }
    }
    
    // Start the clock
    private func start() async {
        let initialDelay: Double = 1 - Double(Date.now.component(.nanosecond))/1E9
        self.tick.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.tick.toggle()
                for countdown in self.countdowns {
                    countdown.tick()
                }
                print("tick")
            }
        }
        isLoaded = true
    }
    
    // Stop the clock
    private func stop() {
        timer?.invalidate()
    }
    
    
    // MARK: - Intents
    
    // Add countdown
    public func add(_ countdown: Countdown) {
        countdowns.append(countdown)
        modelContext.insert(countdown)
    }
    
    // Delete countdown
    public func delete(_ countdown: Countdown) {
        countdowns.removeAll(where: { $0 == countdown })
        modelContext.delete(countdown)
    }
    
    
    // MARK: Conversions
    
    // Open a URL requesting a specific countdown
    public func getCountdown(from url: URL) -> Countdown? {
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
        
        // Find and return the countdown
        return countdowns.first(where: { $0.id == id })
    }
    
    
    
    
    // MARK: Notifications
    
//    public func scheduleNotifications(for countdowns: [Countdown]) {
//        guard notifications else { return }
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//            if success {
//                countdowns.forEach { self.scheduleNotification(for: $0) }
//            } else if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    public func scheduleNotification(for countdown: Countdown) {
//        
//        guard notifications, countdown.isActive, let components = countdown.occasion.components else { return }
//        
//        let content = UNMutableNotificationContent()
//        content.title = countdown.displayName
//        content.body = "It's time for \(countdown.displayName)!"
//        content.sound = UNNotificationSound.default
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request)
//        
//        print("Notification set for \(countdown.name)")
//    }
//    
//    public func unscheduleNotifications(for countdown: Countdown) {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [countdown.id.uuidString])
//        print("Notification removed for \(countdown.name)")
//    }
//    
//    public func unscheduleNotifications() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        print("Notifications removed")
//    }
}
