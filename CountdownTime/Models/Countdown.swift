//
//  Countdown.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Countdown {
    
    var id: String
    
    var name: String
    
    
    // MARK: - Destination
    
    @Attribute private var _destination: Data?
    @Transient var destination: Destination {
        get {
            if let rawDestination = _destination, let destination = try? JSONDecoder().decode(Destination.self, from: rawDestination) {
                return destination
            }
            return .custom(date: .date(.now))
        }
        set {
            if let rawDestination = try? JSONEncoder().encode(newValue) {
                _destination = rawDestination
            }
        }
    }
    
    var date: Date {
        destination.date.next
    }
    func setTimeRemaining() {
        timeRemaining = max(-1, date.timeIntervalSinceNow)
    }
    
    var timeRemaining: Double = 0
    var daysRemaining: Int {
        Int(abs(ceil(timeRemaining/86400)))
    }
    var componentsRemaining: DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: .now.advanced(by: timeRemaining + 1))
    }
    
    
    // MARK: - Backgrounds
    
    @Attribute(.externalStorage) private var _backgroundData: Data?
    @Transient var backgroundData: [BackgroundData] {
        get {
            if let rawBackgroundData = _backgroundData, let backgroundData = try? JSONDecoder().decode([BackgroundData].self, from: rawBackgroundData) {
                return backgroundData
            }
            return []
        }
        set {
            if let rawBackgroundData = try? JSONEncoder().encode(newValue) {
                _backgroundData = rawBackgroundData
            }
        }
    }
    
    @Transient var backgrounds: [Background] = []
    var backgroundIndex: Int?
    var background: Background? {
        guard let backgroundIndex, backgroundIndex < backgrounds.count else { return nil }
        return backgrounds[backgroundIndex]
    }
    
    @Transient var backgroundTimer: Timer?
    var backgroundCycleEnabled: Bool = false
    var backgroundCycleDuration: Double = 7.0
    
    
    // MARK: - Display Settings
    
    @Attribute private var _textPosition: TextPosition.RawValue
    @Transient var textPosition: TextPosition {
        get { TextPosition(rawValue: _textPosition)! }
        set { _textPosition = newValue.rawValue }
    }
    
    @Attribute private var _textDesign: TextDesign.RawValue
    @Transient var textDesign: TextDesign {
        get { TextDesign(rawValue: _textDesign)! }
        set { _textDesign = newValue.rawValue }
    }
    
    
    // MARK: - Initializers
    
    init(name: String, date: Date, emoji: String, color: Color, image: UIImage) {
        self.id = name
        self.name = name
        self._textPosition = 0
        self._textDesign = 0
        self.destination = .custom(date: .date(.now))
    }
    
    init(name: String, destination: Destination) {
        self.id = name
        self.name = name
        self._textPosition = 0
        self._textDesign = 0
        self.destination = destination
    }
    
    init(name: String, date: Date) {
        self.id = name
        self.name = name
        self._textPosition = 0
        self._textDesign = 0
        self.destination = .custom(date: .date(date))
    }
    
    
    // MARK: - Samples
    
    static let samples: [Countdown] = [
        Countdown(name: "Birthday", date: Date().addingTimeInterval(86400 * 276), emoji: "🎁", color: .red, image: UIImage(named: "Birthday")!),
        Countdown(name: "Graduation", date: Date().addingTimeInterval(86400 * 379 + 58347), emoji: "🎓", color: .green, image: UIImage(named: "Birthday")!),
        Countdown(name: "Halloween", date: Date().addingTimeInterval(86400 * 168), emoji: "🎃", color: .purple, image: UIImage(named: "Birthday")!),
        Countdown(name: "Vacation", date: Date().addingTimeInterval(86400 * 2), emoji: "🏝️", color: .cyan, image: UIImage(named: "Birthday")!),
        Countdown(name: "Party", date: Date().addingTimeInterval(86400 * 24 + 12389), emoji: "🥳", color: .orange, image: UIImage(named: "Birthday")!),
//        Countdown(name: "Move In", date: Date().addingTimeInterval(86400 * -37), emoji: "🏡", color: .orange),
//        Countdown(name: "Trip", date: Date().addingTimeInterval(86400 * -119), emoji: "✈️", color: .cyan),
//        Countdown(name: "Birthday", date: Date().addingTimeInterval(86400 * (276 - 365)), emoji: "🎁", color: .purple),
//        Countdown(name: "Game", date: Date().addingTimeInterval(86400 * -28), emoji: "🏆", color: .green)
    ]
}

extension Countdown: Identifiable { }

extension Countdown: Hashable {
    static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
