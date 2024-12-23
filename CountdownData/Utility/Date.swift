//
//  Date.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/19/23.
//

import Foundation

public extension Date {
    
    struct TimeRemaining {
        public var day, hour, minute, second: Int
        static let none = Self(day: 0, hour: 0, minute: 0, second: 0)
    }
    
    func daysRemaining(relativeTo reference: Date = .now) -> Int {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: reference, to: self < reference ? reference : self.midnight.advanced(by: 1))
        guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return 0 }
        return day + (hour <= 0 && minute <= 0 && second <= 0 ? 0 : 1)
    }
    
    func timeRemaining(relativeTo reference: Date = .now) -> TimeRemaining {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: reference, to: self < reference ? reference : self.advanced(by: 1))
        guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return .none }
        return TimeRemaining(day: day, hour: hour, minute: minute, second: second)
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeIntervalSinceNow < 86400*335 && timeIntervalSinceNow > -86400*30 ? "EEE MMM d" : "EEE MMM d yyyy"
        return dateFormatter.string(from: self)
    }
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = component(.minute) == 0 ? "ha" : "h:mma"
        return dateFormatter.string(from: self)
    }
    
    var fullDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    var fullString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    var midnight: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let date = calendar.date(from: components) {
            return date
        } else {
            return self
        }
    }
    
    static var nextHour: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: .now)
        components.minute = 0
        components.second = 0
        
        if let currentHourDate = calendar.date(from: components) {
            if let nextHourDate = calendar.date(byAdding: .hour, value: 1, to: currentHourDate) {
                return nextHourDate
            }
        }
        return .now
    }
    
    init(year: Int? = nil, month: Int, day: Int) {
        let calendar = Calendar.current
        
        var components = DateComponents()
        components.year = year ?? calendar.component(.year, from: .now)
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let date = calendar.date(from: components) {
            self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
        } else {
            self.init()
        }
    }
    
    static var currentYear: Int {
        return Calendar.current.component(.year, from: .now)
    }
    static var currentMonth: Int {
        return Calendar.current.component(.month, from: .now)
    }
    static var currentDay: Int {
        return Calendar.current.component(.day, from: .now)
    }
    static func currentYear(_ identifier: Calendar.Identifier) -> Int {
        return Calendar(identifier: identifier).component(.year, from: .now)
    }
    static func currentMonth(_ identifier: Calendar.Identifier) -> Int {
        return Calendar(identifier: identifier).component(.month, from: .now)
    }
    static func currentDay(_ identifier: Calendar.Identifier) -> Int {
        return Calendar(identifier: identifier).component(.day, from: .now)
    }
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
    }
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now
    }
}
