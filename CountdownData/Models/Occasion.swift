//
//  Occasion.swift
//  CountdownData
//
//  Created by Joe Rupertus on 8/18/23.
//

import Foundation
    
public enum Occasion: Codable, Hashable, Equatable {
    
    // MARK: Single
    
    // Single year, month, day, time
    // i.e. Party => 2023 Dec 31 19:30
    case singleTime(calendar: String, year: Int, month: Int, day: Int, hour: Int, minute: Int)
    
    // Single year, month, day
    // i.e. Graduation => 2022 Jun 02
    case singleDate(calendar: String, year: Int, month: Int, day: Int)
    
    // MARK: Annual
    
    // Repeat same month, day, time annually
    // i.e. Holiday Dinner => Dec 24 17:00
    case annualTime(calendar: String, month: Int, day: Int, hour: Int, minute: Int)
    
    // Repeat same month & day annually
    // i.e. Christmas => Dec 25
    case annualDate(calendar: String, month: Int, day: Int)
    
    // Repeat same month & week annually
    // i.e. Thanksgiving => Nov, 4th Thu
    case annualWeek(calendar: String, month: Int, week: Int, weekday: Int)
    
    // Repeat same month & relative week annually
    // i.e. Victoria Day => May, Mon before 25th
    case annualWeek2(calendar: String, month: Int, weekday: Int, after: Bool, day: Int)
    
    // Repeat annually, date determined somehow
    // i.e. Easter => something computed by algorithm
    case annualOther(calendar: String, tag: String, offset: Int)
    
    // Placeholder
    public static let now = Self.annualDate(calendar: "gregorian", month: Date.currentMonth, day: Date.currentDay)
    
    private var next: (date: Date, components: DateComponents)? {
        switch self {
        case .singleTime(let calendar, let year, let month, let day, let hour, let minute):
            return single(calendar: Calendar.Identifier(calendar), year: year, month: month, day: day, hour: hour, minute: minute)
        case .singleDate(let calendar, let year, let month, let day):
            return single(calendar: Calendar.Identifier(calendar), year: year, month: month, day: day)
        case .annualTime(let calendar, let month, let day, let hour, let minute):
            return annual(calendar: Calendar.Identifier(calendar), month: month, day: day, hour: hour, minute: minute)
        case .annualDate(let calendar, let month, let day):
            return annual(calendar: Calendar.Identifier(calendar), month: month, day: day)
        case .annualWeek(let calendar, let month, let week, let weekday):
            return annual(calendar: Calendar.Identifier(calendar), month: month, week: week, weekday: weekday)
        case .annualWeek2(let calendar, let month, let weekday, let after, let day):
            return annual(calendar: Calendar.Identifier(calendar), month: month, weekday: weekday, after: after, day: day)
        case .annualOther(let calendar, let tag, let offset):
            return annual(calendar: Calendar.Identifier(calendar), tag: tag, offset: offset)
        }
    }
    
    public var date: Date {
        next?.date ?? .distantFuture
    }
    public var components: DateComponents? {
        next?.components
    }
    
    public var includeTime: Bool {
        switch self {
        case .singleTime(_,_,_,_,_,_), .annualTime(_,_,_,_,_): return true
        default: return false
        }
    }
    public var repeatAnnually: Bool {
        switch self {
        case .annualTime(_,_,_,_,_), .annualDate(_,_,_), .annualWeek(_,_,_,_), .annualWeek2(_,_,_,_,_), .annualOther(_,_,_): return true
        default: return false
        }
    }
    
    private func single(calendar identifier: Calendar.Identifier, year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        if let date = calendar.date(from: components) {
            return (date, components)
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        if let date = calendar.date(from: components) {
            if date.midnight < .now.midnight {
                return annual(calendar: identifier, year: year+1, month: month, day: day, hour: hour, minute: minute)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, week: Int, weekday: Int) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        let components = DateComponents(year: year, month: month, weekday: weekday, weekdayOrdinal: week)
        if let date = calendar.date(from: components) {
            if date.midnight < .now.midnight {
                return annual(calendar: identifier, year: year+1, month: month, week: week, weekday: weekday)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, weekday: Int, after: Bool, day: Int) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        let components = DateComponents(year: year, month: month, day: day)
        let baseDate = calendar.date(from: components) ?? .now
        let baseWeekday = baseDate.component(.weekday)
        let offset = (after ? 1 : -1) * (baseWeekday - weekday + 7) % 7
        if let date = calendar.date(byAdding: .day, value: offset, to: baseDate) {
            if date.midnight < .now.midnight {
                return annual(calendar: identifier, year: year+1, month: month, weekday: weekday, after: after, day: day)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, tag: String, offset: Int) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        var components: DateComponents?
        switch tag {
        case "easter": components = easter(for: year)
        default: components = nil
        }
        guard let components else { return nil }
        if let baseDate = calendar.date(from: components), let date = calendar.date(byAdding: .day, value: offset, to: baseDate) {
            if date.midnight < .now.midnight {
                return annual(calendar: identifier, year: year+1, tag: tag, offset: offset)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func easter(for year: Int) -> DateComponents {
        let a = year % 19
        let b = year / 100
        let c = year % 100
        let d = b / 4
        let e = b % 4
        let g = (8 * b + 13) / 25
        let h = (19 * a + b - d - g + 15) % 30
        let i = c / 4
        let k = c % 4
        let l = (32 + 2 * e + 2 * i - h - k) % 7
        let m = (a + 11 * h + 19 * l) / 433
        let month = (h + l - 7 * m + 90) / 25
        let day = (h + l - 7 * m + 33 * month + 19) % 32
        return DateComponents(year: year, month: month, day: day)
    }
}
