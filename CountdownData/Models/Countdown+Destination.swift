//
//  Countdown+Destination.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/21/23.
//

import Foundation
import EventKit

extension Countdown {
    
    public enum DestinationType: String, CaseIterable, Identifiable {
        
        case holiday
        case birthday
        case custom
        
        public var id: Self { self }
    }
    
    public enum Destination: Codable, CaseIterable, Hashable {
        
        case holiday(name: String)
        case birthday(year: Int, month: Int, day: Int)
        case custom(date: EventDate)
        
        public var date: EventDate {
            switch self {
            case .holiday(let name):
                return Holiday(named: name)?.date ?? .date(.now)
            case .birthday(_, let month, let day):
                return .repeatDayYearly(month: month, day: day)
            case .custom(let date):
                return date
            }
        }
        
        public var type: DestinationType {
            switch self {
            case .holiday(_):
                return .holiday
            case .birthday(_, _, _):
                return .birthday
            case .custom(_):
                return .custom
            }
        }
        
        public var name: String {
            switch self {
            case .holiday(_):
                return "Holiday"
            case .birthday:
                return "Birthday"
            case .custom(_):
                return "Custom"
            }
        }
        
        public static var allCases: [Countdown.Destination] = [.holiday(name: ""), .birthday(year: 0, month: 0, day: 0), .custom(date: .date(.now))]
    }
}
