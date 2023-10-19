//
//  Countdown+EventDate.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/18/23.
//

import Foundation

extension Countdown {
    
    enum EventDate: Codable, Hashable, Equatable {
        
        case date(_ date: Date)
        case multiDate(_ dates: [Date])
        case repeatDayYearly(calendar: Calendar.Identifier = .gregorian, month: Int, day: Int)
        case repeatWeekYearly(calendar: Calendar.Identifier = .gregorian, month: Int, week: Int, day: Int)
        
        var description: String {
            switch self {
            case .date(let date):
                return date.fullString
            case .multiDate(_):
                return "Varying dates"
            case .repeatDayYearly(let calendar, _, _):
                return "Every year on \(next.string(in: calendar))"
            case .repeatWeekYearly(_, let month, let week, let day):
                return "Every year on the \(week.ordinalString) \(day.weekdayName()) of \(month.monthName())"
            }
        }
        
        var next: Date {
            switch self {
            case .date(let date):
                return date
            case .multiDate(let dates):
                return dates.first ?? .now
            case .repeatDayYearly(let calendar, let month, let day):
                return date(calendar: calendar, month: month, day: day)
            case .repeatWeekYearly(let calendar, let month, let week, let day):
                return date(calendar: calendar, month: month, week: week, day: day)
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
    }
}
