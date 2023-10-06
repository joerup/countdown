//
//  Countdown+Holiday.swift
//
//
//  Created by Joe Rupertus on 8/29/23.
//

import Foundation

extension Countdown {
    
    public struct Holiday: Codable, Hashable {
        
        public var name: String
        public var displayName: String
        public var date: Countdown.EventDate
        
        fileprivate init(name: String, displayName: String? = nil, date: Countdown.EventDate) {
            self.name = name
            self.displayName = displayName ?? name
            self.date = date
        }
        
        public init?(named name: String) {
            guard let holiday = Self.all.first(where: { $0.name == name }) else { return nil }
            self.name = holiday.name
            self.displayName = holiday.displayName
            self.date = holiday.date
        }
        
        public static var all: [Holiday] = [
            
            // National Holidays
            Holiday(name: "Memorial Day (U.S.)", displayName: "Memorial Day", date: .repeatWeekYearly(month: 5, week: -1, day: 2)),
            Holiday(name: "Canada Day (Canada)", displayName: "Canada Day", date: .repeatDayYearly(month: 7, day: 1)), // add victoria day
            Holiday(name: "Independence Day (U.S.)", displayName: "Independence Day", date: .repeatDayYearly(month: 7, day: 4)),
            Holiday(name: "Bastille Day (France)", displayName: "Bastille Day", date: .repeatDayYearly(month: 7, day: 14)),
            Holiday(name: "Labor Day (U.S.)", displayName: "Labor Day", date: .repeatWeekYearly(month: 9, week: 1, day: 2)),
            Holiday(name: "Thanksgiving (Canada)", displayName: "Thanksgiving", date: .repeatWeekYearly(month: 10, week: 2, day: 2)),
            Holiday(name: "Thanksgiving (U.S.)", displayName: "Thanksgiving", date: .repeatWeekYearly(month: 11, week: 4, day: 5)),
            
            // Mother/Father Days
            Holiday(name: "Mother's Day", displayName: "Mother's Day", date: .repeatWeekYearly(month: 5, week: 2, day: 1)),
            Holiday(name: "Father's Day", displayName: "Father's Day", date: .repeatWeekYearly(month: 6, week: 3, day: 1)),
            
            // Christianity
            Holiday(name: "Mardi Gras", date: .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear).addingTimeInterval(-46*86400) }))),
            Holiday(name: "Ash Wednesday", date: .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear).addingTimeInterval(-45*86400) }))),
            Holiday(name: "Good Friday", date: .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear).addingTimeInterval(-2*86400) }))),
            Holiday(name: "Easter", date: .multiDate([1,2,3,4,5].map({ calculateEasterDate(for: $0 + Date.currentYear) }))),
            Holiday(name: "Christmas", date: .repeatDayYearly(month: 12, day: 25)),
            
            // Chinese
            Holiday(name: "Chinese New Year", date: .repeatDayYearly(calendar: .chinese, month: 1, day: 1)),
            
            // Islam
            Holiday(name: "Ramadan", date: .repeatDayYearly(calendar: .islamic, month: 9, day: 1)),
            Holiday(name: "Eid Al-Fitr", date: .repeatDayYearly(calendar: .islamic, month: 10, day: 1)),
            Holiday(name: "Eid Al-Adha", date: .repeatDayYearly(calendar: .islamic, month: 12, day: 10)),
            
            // Judaism
            Holiday(name: "Rosh Hashanah", date: .repeatDayYearly(calendar: .hebrew, month: 1, day: 1)),
            Holiday(name: "Yom Kippur", date: .repeatDayYearly(calendar: .hebrew, month: 1, day: 10)),
            Holiday(name: "Hanukkah", date: .repeatDayYearly(calendar: .hebrew, month: 3, day: 25)),
            Holiday(name: "Passover", date: .repeatDayYearly(calendar: .hebrew, month: 8, day: 15)),
            
            // Miscellaneous
            Holiday(name: "New Year", date: .repeatDayYearly(month: 1, day: 1)),
            Holiday(name: "Valentine's Day", date: .repeatDayYearly(month: 2, day: 14)),
            Holiday(name: "St. Patrick's Day", date: .repeatDayYearly(month: 3, day: 17)),
            Holiday(name: "Halloween", date: .repeatDayYearly(month: 10, day: 31)),
            Holiday(name: "Kwanzaa", date: .repeatDayYearly(month: 12, day: 26))
            
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
