//
//  Occasion.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/18/23.
//

import Foundation
    
public enum Occasion: Codable, Hashable, Equatable {
    
    case singleDate(_ date: Date)
    case multiDate(_ dates: [Date])
    
    case annualDate(calendar: String, month: Int, day: Int)
    case annualWeek(calendar: String, month: Int, week: Int, day: Int)
    case annualOther(calendar: String, tag: String, offset: Int)
    
    public var next: Date {
        switch self {
        case .singleDate(let date):
            return date
        case .multiDate(let dates):
            return dates.first ?? .now
        case .annualDate(let calendar, let month, let day):
            return date(calendar: Calendar.Identifier(calendar), month: month, day: day)
        case .annualWeek(let calendar, let month, let week, let day):
            return date(calendar: Calendar.Identifier(calendar), month: month, week: week, day: day)
        case .annualOther(let calendar, let tag, let offset):
            return date(calendar: Calendar.Identifier(calendar), tag: tag, offset: offset)
        }
    }
    
    private func date(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: identifier)
        var components = DateComponents()
        let year = year ?? Date.currentYear(identifier)
        
        components.year = year
        components.month = month
        components.day = day
         
        if let date = calendar.date(from: components) {
            if date < .now {
                return self.date(calendar: identifier, year: year+1, month: month, day: day)
            } else {
                return date
            }
        }
        return .now
    }
    
    private func date(calendar identifier: Calendar.Identifier, year: Int? = nil, month: Int, week: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: identifier)
        var components = DateComponents()
        let year = year ?? Date.currentYear(identifier)
        
        components.year = year
        components.month = month
        components.weekdayOrdinal = week
        components.weekday = day
         
        if let date = calendar.date(from: components) {
            if date < .now {
                return self.date(calendar: identifier, year: year+1, month: month, week: week, day: day)
            } else {
                return date
            }
        }
        return .now
    }
    
    private func date(calendar identifier: Calendar.Identifier, year: Int? = nil, tag: String, offset: Int) -> Date {
        let calendar = Calendar(identifier: identifier)
        var components = DateComponents()
        let year = year ?? Date.currentYear(identifier)
        
        var dateComponents: (year: Int, month: Int, day: Int)?
        switch tag {
        case "easter": dateComponents = easter(for: year)
        default: dateComponents = nil
        }
        guard let dateComponents else { return .now }
        
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        
        if let baseDate = calendar.date(from: components), let date = calendar.date(byAdding: .day, value: offset, to: baseDate) {
            if date < .now {
                return self.date(calendar: identifier, year: year+1, tag: tag, offset: offset)
            } else {
                return date
            }
        }
        return .now
    }
    
    private func easter(for year: Int) -> (year: Int, month: Int, day: Int) {
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
        return (year, month, day)
    }
}
