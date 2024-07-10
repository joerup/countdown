//
//  Clock.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/19/23.
//

import Foundation
import UserNotifications
import SwiftUI

public final class Clock: ObservableObject {
    
    @Published public var tick: Bool
    @Published public var isActive: Bool
    
    @AppStorage("notifications") public var notifications: Bool = true
    
    public private(set) var delay: Double = 0.35
    
    private var timer: Timer?
    
    public init() {
        self.tick = false
        self.isActive = false
    }
    deinit {
        stop()
    }
    
    
    // MARK: Controls
    
    public func start(countdowns: [Countdown]) async {
        
        // Schedule all notifications
        scheduleNotifications(for: countdowns)
        
        // Schedule the timer
        timer?.invalidate()
        let initialDelay: Double = 1 - Double(Date.now.component(.nanosecond))/1E9
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.isActive {
                    self.tick.toggle()
                }
            }
        }
        
        await MainActor.run {
            self.isActive = true
        }
    }
    
    public func stop() {
        timer?.invalidate()
        self.isActive = false
    }
    
    public func ready() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isActive = true
        }
    }
    
    public func pause() {
        self.isActive = false
    }
    
    public func pause(execute: () -> Void) {
        pause()
        withAnimation(.easeInOut(duration: delay)) {
            execute()
        }
        ready()
    }
    
//    public func refresh(countdowns: [Countdown]) async {
//        await fetchCardsAndBackgrounds(for: countdowns)
//    }
    
    
    // MARK: Calculations
    
//    public func daysRemaining(for countdown: Countdown) -> Int {
//        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: countdown.date < .now ? .now : countdown.date.midnight.advanced(by: 1))
//        guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return 0 }
//        return day + (hour <= 0 && minute <= 0 && second <= 0 ? 0 : 1)
//    }
//    
//    public func componentsRemaining(for countdown: Countdown) -> DateComponents {
//        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: countdown.date < .now ? .now : countdown.date.advanced(by: 1))
//    }
    
    
    // MARK: Notifications
    
    public func scheduleNotifications(for countdowns: [Countdown]) {
        guard notifications else { return }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                countdowns.forEach { self.scheduleNotification(for: $0) }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func scheduleNotification(for countdown: Countdown) {
        
        guard notifications, countdown.isActive, let components = countdown.occasion.components else { return }
        
        let content = UNMutableNotificationContent()
        content.title = countdown.displayName
        content.body = "It's time for \(countdown.displayName)!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: countdown.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
        
        print("Notification set for \(countdown.name)")
    }
    
    public func unscheduleNotifications(for countdown: Countdown) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [countdown.id.uuidString])
        print("Notification removed for \(countdown.name)")
    }
    
    public func unscheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Notifications removed")
    }
}
