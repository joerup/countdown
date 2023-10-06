//
//  Countdown+EventDate.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/18/23.
//

import Foundation

extension Countdown {
    
    public enum EventDate: Codable, Hashable, Equatable {
        
        case date(_ date: Date)
        case multiDate(_ dates: [Date])
        case repeatDayYearly(calendar: Calendar.Identifier = .gregorian, month: Int, day: Int)
        case repeatWeekYearly(calendar: Calendar.Identifier = .gregorian, month: Int, week: Int, day: Int)
        
        public var repeatDescription: String {
            switch self {
            case .date(let date):
                return date.fullString
            case .multiDate(_):
                return "Occurs every year based on the date of Easter."
            case .repeatDayYearly(let calendar, let month, let day):
                return calendar == .gregorian ? "Occurs annually on \(next.mdString)." :
                month == 1 && day == 1 && calendar == .chinese ? "Occurs on the first day of the \(calendar.name) year." :
                "Occurs on the \(day.ordinalString) day of \(month.monthName(calendar)) (\(calendar.name) calendar)."
            case .repeatWeekYearly(_, let month, let week, let day):
                return "Occurs annually on the \(week.ordinalString) \(day.weekdayName()) of \(month.monthName())."
            }
        }
        
        public var next: Date {
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
            components.hour = 0
            components.minute = 0
            components.second = 0
             
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
