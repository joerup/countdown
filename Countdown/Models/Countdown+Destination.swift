//
//  Countdown+Destination.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/21/23.
//

import Foundation
import EventKit

extension Countdown {
    
    enum Destination: Codable, CaseIterable, Hashable {
        
        case holiday(name: String)
        case birthday
        case calendar(event: String)
        case custom(date: EventDate)
        
        var date: EventDate {
            switch self {
            case .holiday(let name):
                return Destination.holidays[name] ?? .date(.now)
            case .calendar(let event):
                return .date(EKEvent.getEvent(id: event)?.startDate ?? .now)
            case .custom(let date):
                return date
            default:
                return .date(.now)
            }
        }
        
        var name: String {
            switch self {
            case .holiday(_):
                return "Holiday"
            case .birthday:
                return "Birthday"
            case .calendar:
                return "Other"
            case .custom(_):
                return "Other"
            }
        }
        
        static var allCases: [Countdown.Destination] = [.holiday(name: ""), .birthday, .calendar(event: ""), .custom(date: .date(.now))]
        
        static var holidays: [String:EventDate] = [
            "Memorial Day" : .repeatWeekYearly(month: 5, week: -1, day: 2),
            "Halloween" : .repeatDayYearly(month: 10, day: 31),
            "Thanksgiving" : .repeatWeekYearly(month: 11, week: 4, day: 5),
            "Christmas" : .repeatDayYearly(month: 12, day: 25),
            "New Year" : .repeatDayYearly(month: 1, day: 1),
            "Valentine's Day" : .repeatDayYearly(month: 2, day: 14),
            "Chinese New Year" : .repeatDayYearly(calendar: .chinese, month: 1, day: 1),
            "Eid Al-Fitr" : .repeatDayYearly(calendar: .islamic, month: 10, day: 1),
            "Eid al-Adha" : .repeatDayYearly(calendar: .islamic, month: 12, day: 10),
            "Islamic New Year" : .repeatDayYearly(calendar: .islamic, month: 1, day: 1),
            "Ramadan" : .repeatDayYearly(calendar: .islamic, month: 9, day: 1),
            "Rosh Hashanah" : .repeatDayYearly(calendar: .hebrew, month: 1, day: 1),
            "Yom Kippur" : .repeatDayYearly(calendar: .hebrew, month: 1, day: 10),
            "Diwali" : .repeatDayYearly(calendar: .indian, month: 8, day: 15), // not the right date for some reason
            "Holi" : .repeatDayYearly(calendar: .indian, month: 12, day: 15),
            "Hanukkah" : .repeatDayYearly(calendar: .hebrew, month: 3, day: 25),
            "Passover" : .repeatDayYearly(calendar: .hebrew, month: 8, day: 15),
            "Easter" : .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear) })),
            "Good Friday" : .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear).addingTimeInterval(-2*86400) })),
            "Ash Wednesday" : .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear).addingTimeInterval(-45*86400) })),
            "Mardi Gras" : .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear).addingTimeInterval(-46*86400) })),
            "Independence Day" : .repeatDayYearly(month: 7, day: 4),
            "St. Patrick's Day" : .repeatDayYearly(month: 3, day: 17),
            "Kwanzaa" : .repeatDayYearly(month: 12, day: 26),
        ]
        
        private static func calculateEasterDate(for year: Int) -> Date {
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
            let n = (h + l - 7 * m + 90) / 25
            let p = (h + l - 7 * m + 33 * n + 19) % 32
            
            let calendar = Calendar(identifier: .gregorian)
            var components = DateComponents()
            components.year = year
            components.month = n
            components.day = p
            
            return calendar.date(from: components) ?? .now
        }
    }
}
