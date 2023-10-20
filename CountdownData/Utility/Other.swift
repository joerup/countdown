//
//  Other.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import Foundation
import SwiftUI
import UIKit
import EventKit


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

extension Calendar.Identifier {

    public init(_ string: String) {
        switch string {
        case "gregorian": self = .gregorian
        case "hebrew": self = .hebrew
        case "chinese": self = .chinese
        case "islamic": self = .islamicCivil
        case "hindu": self = .indian
        default: self = .iso8601
        }
    }
    
    public var name: String {
        return String("\(self)").capitalized
    }
    
}
