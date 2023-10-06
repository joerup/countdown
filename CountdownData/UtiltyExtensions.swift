//
//  UtiltyExtensions.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import Foundation
import SwiftUI
import UIKit
import EventKit

public extension Date {
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeIntervalSinceNow < 86400*365 ? "EEE MMM dd" : "EEE MMM dd YYYY"
        return dateFormatter.string(from: self)
    }
    var fullString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
    var mdString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        return dateFormatter.string(from: self)
    }
    
    func string(in identifier: Calendar.Identifier) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: identifier)
        dateFormatter.dateFormat = "MMMM d"
        return dateFormatter.string(from: self)
    }
    
    func component(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    static var midnight: Date {
        let calendar = Calendar.current
        let now = Date()
        
        var components = DateComponents()
        components.year = calendar.component(.year, from: now)
        components.month = calendar.component(.month, from: now)
        components.day = calendar.component(.day, from: now)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        if let date = calendar.date(from: components) {
            return date
        } else {
            return now
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
    static func currentYear(_ identifier: Calendar.Identifier) -> Int {
        return Calendar(identifier: identifier).component(.year, from: .now)
    }
    static func currentMonth(_ identifier: Calendar.Identifier) -> Int {
        return Calendar(identifier: identifier).component(.month, from: .now)
    }
    
    static func startOfMonthOffset(_ month: Int) -> Int {
        return Date(month: month, day: 1).component(.weekday) - 1
    }
    static func daysInMonth(_ month: Int) -> Range<Int> {
        return Calendar.current.range(of: .day, in: .month, for: Date(month: month, day: 1)) ?? 0..<1
    }
    
    enum Weekday: Int, Codable, CaseIterable, Hashable {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
    
    enum WeekNumber: Int, Codable, CaseIterable, Hashable {
        case first = 1
        case second = 2
        case third = 3
        case fourth = 4
        case fifth = 5
        case last = -1
    }
}

public extension Color {
    
    init(rgb: [Double]) {
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2])
    }
    
    var rgb: [Double] {
        guard let components = colorComponents else { return [0,0,0] }
        return [components.red, components.green, components.blue]
    }
    
    var red: Double {
        return rgb[0]
    }
    var green: Double {
        return rgb[1]
    }
    var blue: Double {
        return rgb[2]
    }
    
    func lighter(by percentage: CGFloat = 0.5) -> Color {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 0.5) -> Color {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 0.5) -> Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Color(UIColor(red: red + percentage*(1-red),
                           green: green + percentage*(1-green),
                           blue: blue + percentage*(1-blue),
                           alpha: alpha))
        } else {
            return self
        }
    }
    
    func inverted() -> Color {
        return Color(rgb: [1-red, 1-green, 1-blue])
    }
}


fileprivate extension Color {
    typealias SystemColor = UIColor
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
        
        return (r, g, b, a)
    }
}

extension Color: Codable {
    
    enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        
        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}

public extension EKEvent {
    
    static let store = EKEventStore()
    
    static func getAllEvents() -> [EKEvent] {
        var events: [EKEvent] = []
        
        store.requestFullAccessToEvents { granted, error in
            if granted {
                let nextYear = Date().advanced(by: 365 * 86400)
                let predicate = store.predicateForEvents(withStart: .now, end: nextYear, calendars: nil)
                events = store.events(matching: predicate)
            }
        }
        
        return events
    }
    
    static func getEvent(id: String) -> EKEvent? {
        return getAllEvents().first(where: { $0.eventIdentifier == id })
    }
}

public extension GeometryProxy {
    
    var totalSize: CGSize {
        CGSize(width: size.width + safeAreaInsets.leading + safeAreaInsets.trailing, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
    }
}

public extension Int {
    
    var ordinalString: String {
        if self == -1 {
            return "last"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: self) ?? String(self)
    }
    
    func monthName(_ identifier: Calendar.Identifier = .gregorian) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: identifier)
        dateFormatter.dateFormat = "MMMM"
        if let date = Calendar(identifier: identifier).date(from: DateComponents(month: self)) {
            return dateFormatter.string(from: date)
        }
        return "None"
    }
    
    func weekdayName(_ identifier: Calendar.Identifier = .gregorian) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: identifier)
        dateFormatter.dateFormat = "EEEE"
        if let date = Calendar(identifier: identifier).date(from: DateComponents(year: 2000, month: 1, weekday: self, weekdayOrdinal: 1)) {
            return dateFormatter.string(from: date)
        }
        return "None"
    }
}

public extension Calendar.Identifier {
    var name: String {
        return String("\(self)").capitalized
    }
}
