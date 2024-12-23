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
        return next(after: .now)
    }
    private func next(after referenceDate: Date) -> (date: Date, components: DateComponents)? {
        switch self {
        case .singleTime(let calendar, let year, let month, let day, let hour, let minute):
            return single(calendar: Calendar.Identifier(calendar), year: year, month: month, day: day, hour: hour, minute: minute)
        case .singleDate(let calendar, let year, let month, let day):
            return single(calendar: Calendar.Identifier(calendar), year: year, month: month, day: day)
        case .annualTime(let calendar, let month, let day, let hour, let minute):
            return annual(calendar: Calendar.Identifier(calendar), month: month, day: day, hour: hour, minute: minute, after: referenceDate)
        case .annualDate(let calendar, let month, let day):
            return annual(calendar: Calendar.Identifier(calendar), month: month, day: day, after: referenceDate)
        case .annualWeek(let calendar, let month, let week, let weekday):
            return annual(calendar: Calendar.Identifier(calendar), month: month, week: week, weekday: weekday, after: referenceDate)
        case .annualWeek2(let calendar, let month, let weekday, let after, let day):
            return annual(calendar: Calendar.Identifier(calendar), month: month, weekday: weekday, after: after, day: day, after: referenceDate)
        case .annualOther(let calendar, let tag, let offset):
            return annual(calendar: Calendar.Identifier(calendar), tag: tag, offset: offset, after: referenceDate)
        }
    }
    
    public var date: Date {
        next?.date ?? .distantFuture
    }
    public var components: DateComponents? {
        next?.components
    }
    
    public func futureDates(_ amount: Int) -> [Date] {
        var dates: [Date] = []
        if let date = next?.date {
            dates.append(date)
        }
        while dates.count < amount {
            let reference = (dates.last ?? .now).advanced(by: 86400)
            if let date = next(after: reference)?.date {
                dates.append(date)
            }
        }
        return dates
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
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, day: Int, hour: Int = 0, minute: Int = 0, after referenceDate: Date = .now) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        if let date = calendar.date(from: components) {
            if date.midnight < referenceDate.midnight {
                return annual(calendar: identifier, year: year+1, month: month, day: day, hour: hour, minute: minute, after: referenceDate)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, week: Int, weekday: Int, after referenceDate: Date = .now) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        let components = DateComponents(year: year, month: month, weekday: weekday, weekdayOrdinal: week)
        if let date = calendar.date(from: components) {
            if date.midnight < referenceDate.midnight {
                return annual(calendar: identifier, year: year+1, month: month, week: week, weekday: weekday, after: referenceDate)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, weekday: Int, after: Bool, day: Int, after referenceDate: Date = .now) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        let components = DateComponents(year: year, month: month, day: day)
        let baseDate = calendar.date(from: components) ?? .now
        let baseWeekday = baseDate.component(.weekday)
        let offset = (after ? 1 : -1) * (baseWeekday - weekday + 7) % 7
        if let date = calendar.date(byAdding: .day, value: offset, to: baseDate) {
            if date.midnight < referenceDate.midnight {
                return annual(calendar: identifier, year: year+1, month: month, weekday: weekday, after: after, day: day, after: referenceDate)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    private func annual(calendar identifier: Calendar.Identifier, year: Int? = nil, tag: String, offset: Int, after referenceDate: Date = .now) -> (date: Date, components: DateComponents)? {
        let calendar = Calendar(identifier: identifier)
        let year = year ?? Date.currentYear(identifier)
        var components: DateComponents?
        switch tag {
        case "easter": components = easter(for: year)
        case "orthodox_easter": components = orthodoxEaster(for: year)
        default: components = nil
        }
        guard let components else { return nil }
        if let baseDate = calendar.date(from: components), let date = calendar.date(byAdding: .day, value: offset, to: baseDate) {
            if date.midnight < referenceDate.midnight {
                return annual(calendar: identifier, year: year+1, tag: tag, offset: offset, after: referenceDate)
            } else {
                return (date, components)
            }
        }
        return nil
    }
    
    public var string: String {
        switch self {
        case .singleTime(let calendar, let year, let month, let day, let hour, let minute):
            return "\(formattedDate(calendar: calendar, month: month, day: day, year: year)) at \(formattedTime(hour: hour, minute: minute))"
            
        case .singleDate(let calendar, let year, let month, let day):
            return "\(formattedDate(calendar: calendar, month: month, day: day, year: year))"
            
        case .annualTime(let calendar, let month, let day, let hour, let minute):
            return "Annually on \(formattedDate(calendar: calendar, month: month, day: day)) at \(formattedTime(hour: hour, minute: minute))"
            
        case .annualDate(let calendar, let month, let day):
            return "Annually on \(formattedDate(calendar: calendar, month: month, day: day))"
            
        case .annualWeek(let calendar, let month, let week, let weekday):
            let weekdayName = weekdayName(for: weekday, in: calendar)
            return "Annually on the \(week.ordinalString) \(weekdayName) of \(formattedMonth(calendar: calendar, month: month))"
            
        case .annualWeek2(let calendar, let month, let weekday, let after, let day):
            let weekdayName = weekdayName(for: weekday, in: calendar)
            let relative = after ? "after" : "before"
            return "Annually on the \(weekdayName) on or \(relative) \(formattedDate(calendar: calendar, month: month, day: day))"
            
        case .annualOther(_, let tag, let offset):
            if offset != 0 {
                return "Annually \(offset > 0 ? "\(offset) days after" : "\(-offset) days before") \(tag.capitalized)"
            } else {
                switch tag {
                case "easter": return "Annually on the Sunday following the first full moon after the spring equinox"
                case "orthodox_easter": return "Annually on the Sunday following the first full moon after the spring equinox, based on the Julian calendar"
                default: return ""
                }
            }
        }
    }

    private func formattedTime(hour: Int, minute: Int) -> String {
        String(format: "%02d:%02d", hour, minute)
    }
    
    private func formattedDate(calendar identifier: String, month: Int, day: Int, year: Int? = nil) -> String {
        let calendar = Calendar(identifier: Calendar.Identifier(identifier))
        var components = DateComponents()
        components.calendar = calendar
        components.month = month
        components.day = day
        if let year = year {
            components.year = year
        }
        
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        var extraText = ""
        switch calendar.identifier {
            case .gregorian:
                formatter.dateFormat = (year == nil) ? "MMMM d" : "MMMM d, yyyy"
                
            case .hebrew:
                formatter.dateFormat = (year == nil) ? "d MMMM" : "d MMMM, yyyy"
                extraText = " (Hebrew Calendar)"
                
            case .chinese:
                formatter.dateFormat = (year == nil) ? "'month 'M', day 'd" : "'year 'yyyy', month 'M', day 'd"
                extraText = " (Chinese Lunar Calendar)"
                
            case .islamic, .islamicCivil, .islamicTabular, .islamicUmmAlQura:
                formatter.dateFormat = (year == nil) ? "d MMMM" : "d MMMM yyyy"
                extraText = " (Islamic Calendar)"
                
            default:
                formatter.dateFormat = (year == nil) ? "MMMM d" : "MMMM d, yyyy"
            }
        
        if let date = calendar.date(from: components) {
            return formatter.string(from: date) + extraText
        }
        return "\(month)/\(day)" + (year != nil ? "/\(year!)" : "")
    }

    private func weekdayName(for weekday: Int, in identifier: String) -> String {
        let calendar = Calendar(identifier: Calendar.Identifier(identifier))

        let referenceComponents = DateComponents(year: 2000, month: 1, day: 2)
        guard let referenceDate = calendar.date(from: referenceComponents) else {
            return "Invalid Reference Date"
        }
        let dayOffset = weekday - 1
        guard let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: referenceDate) else {
            return "Invalid Target Date"
        }

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE"

        return formatter.string(from: targetDate)
    }


    private func formattedMonth(calendar identifier: String, month: Int) -> String {
        let calendar = Calendar(identifier: Calendar.Identifier(identifier))

        var components = DateComponents()
        components.year = 2000
        components.month = month
        components.day = 1
        
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMMM"

        if let date = calendar.date(from: components) {
            return formatter.string(from: date)
        }
        return ""
    }

}


extension Occasion {
    
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
    
    private func orthodoxEaster(for year: Int) -> DateComponents {
        let a = year % 19
        let b = year % 7
        let c = year % 4
        let d = (19 * a + 16) % 30
        let e = (2 * c + 4 * b + 6 * d) % 7
        var day = 3 + d + e
        var month = 4
        if day > 30 {
            day -= 30
            month = 5
        }
        return DateComponents(year: year, month: month, day: day)
    }

}
