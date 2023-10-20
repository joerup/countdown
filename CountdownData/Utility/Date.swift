//
//  Date.swift
//
//
//  Created by Joe Rupertus on 10/19/23.
//

import Foundation

public extension Date {
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeIntervalSinceNow < 86400*365 ? "EEE MMM dd" : "EEE MMM dd YYYY"
        return dateFormatter.string(from: self)
    }
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = component(.minute) == 0 ? "ha" : "h:mma"
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
        var components = DateComponents()
        components.year = calendar.component(.year, from: self)
        components.month = calendar.component(.month, from: self)
        components.day = calendar.component(.day, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let date = calendar.date(from: components) {
            return date
        } else {
            return self
        }
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
}
