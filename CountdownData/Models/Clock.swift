//
//  Clock.swift
// 
//
//  Created by Joe Rupertus on 10/19/23.
//

import Foundation
import UserNotifications
import SwiftUI

public final class Clock: ObservableObject {
    
    @Published public var tick: Bool
    
    @Published public var active: Bool
    
    private var times: [UUID : Double]
    
    public init() {
        self.tick = false
        self.active = true
        self.times = [:]
    }
    
    public func pause() {
        self.active = false
    }
    public func ready() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.active = true
        }
    }
    public func pause(execute: () -> Void) {
        pause()
        withAnimation(.easeInOut(duration: 0.35)) {
            execute()
        }
        ready()
    }
    
    
    // MARK: Timers
    
    public func setTimeRemaining(for countdown: Countdown) {
        times[countdown.id] = countdown.date.timeIntervalSinceNow
    }
    
    public func timeRemaining(for countdown: Countdown) -> Double? {
        return times[countdown.id]
    }
    
    public func daysRemaining(for countdown: Countdown) -> Int {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: countdown.date < .now ? .now : countdown.date.midnight)
        guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return 0 }
        return day + (hour <= 0 && minute <= 0 && second <= 0 ? 0 : 1)
    }
    
    public func componentsRemaining(for countdown: Countdown) -> DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: countdown.date < .now ? .now : countdown.date)
    }
    
    
    // MARK: Notifications
    
    public func scheduleNotifications(for countdowns: [Countdown]) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                countdowns.forEach { self.scheduleNotification(for: $0) }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func scheduleNotification(for countdown: Countdown) {
        guard let components = countdown.occasion.components else { return }
        
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
    }
}
