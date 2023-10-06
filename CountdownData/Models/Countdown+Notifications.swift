//
//  Countdown+Notifications.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/17/23.
//

import Foundation
import UserNotifications

extension Countdown {
    
    public enum AlertTime: Int, Codable, CaseIterable {
        case oneDay
        case twoDays
        case threeDays
        case oneWeek
        
        public var title: String {
            switch self {
            case .oneDay:
                return "1 Day Left"
            case .twoDays:
                return "2 Days Left"
            case .threeDays:
                return "3 Days Left"
            case .oneWeek:
                return "1 Week Left"
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Notification set")
    }
}
