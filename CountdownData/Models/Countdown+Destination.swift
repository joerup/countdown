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
        
        public static let availableCases: [Self] = [.holiday, .custom]
        
        public var id: Self { self }
    }
    
    public enum Destination: Codable, CaseIterable, Hashable {
        
        case holiday(id: Int)
        case birthday(year: Int, month: Int, day: Int)
        case custom(date: Occasion)
        
        public static let now = Self.custom(date: .singleDate(.now))
        public static func date(_ date: Date) -> Self {
            return Self.custom(date: .singleDate(date))
        }
        
        public var date: Occasion {
            switch self {
            case .holiday(let id):
                return Holiday.get(from: id)?.date ?? .singleDate(.now)
            case .birthday(_, let month, let day):
                return .annualDate(calendar: "gregorian", month: month, day: day)
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
        
        public static var allCases: [Countdown.Destination] = [.holiday(id: -1), .birthday(year: 0, month: 0, day: 0), .custom(date: .singleDate(.now))]
    }
}
