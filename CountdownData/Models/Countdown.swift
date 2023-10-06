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
public final class Countdown {
    
    public var id: String
    public var name: String
    
    // MARK: - Destination
    
    @Attribute private var _destination: Data?
    @Transient public var destination: Destination {
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
    
    public var displayName: String {
        if case .birthday(let year, _, _) = destination {
            return "\(name == "My Birthday" ? "" : "\(name)'s ")\((date.component(.year) - year).ordinalString) Birthday"
        } else {
            return name
        }
    }
    
    public var date: Date {
        destination.date.next
    }
    public func setTimeRemaining() {
        timeRemaining = max(-1, date.timeIntervalSinceNow)
    }
    
    public var timeRemaining: Double = 0
    public var daysRemaining: Int {
        (Calendar.current.dateComponents([.second], from: .now, to: .now.advanced(by: timeRemaining + 1)).second ?? 0) / 86400
    }
    public var componentsRemaining: DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: .now.advanced(by: timeRemaining + 1))
    }
    
    
    // MARK: - Alerts
    
    public var alertsOn: Bool = true
    public var alerts: Set<AlertTime> = []
    
    
    // MARK: - Cards
    
    @Relationship(deleteRule: .cascade) private var cards: [Card] = []
    
    @Transient public var card: Card {
        return cards.first ?? Card()
    }
    @Transient public var cardIndex: Int?
    @Transient public var cardTimer: Timer?
    public var cardCycleEnabled: Bool = false
    public var cardCycleDuration: Double = 7.0
    
    
    // MARK: - Initializers
    
    public init(name: String, date: Date, emoji: String, color: Color, image: UIImage) {
        self.id = name
        self.name = name
        self.destination = .custom(date: .date(.now))
    }
    
    public init(name: String, destination: Destination) {
        self.id = name
        self.name = name
        self.destination = destination
    }
    
    public init(name: String, date: Date) {
        self.id = name
        self.name = name
        self.destination = .custom(date: .date(date))
    }
    
    
    // MARK: - Samples
    
    public static let samples: [Countdown] = [
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
    
    public func loadCards() async {
        for card in cards {
            await card.loadBackground()
        }
    }
    
    public func addCard(_ card: Card) {
        cards.append(card)
    }
    public func removeCard(at index: Int) {
        cards.remove(at: index)
    }
    
    public func startCardTimer() {
        cardTimer?.invalidate()
        guard cardCycleEnabled, cards.count > 1 else { return }
        cardTimer = Timer.scheduledTimer(withTimeInterval: cardCycleDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2.0)) {
                self.cycleCards()
            }
        }
    }
    public func stopCardTimer() {
        cardTimer?.invalidate()
    }
    public func cycleCards() {
        guard let cardIndex else { return }
        if cardIndex+1 < cards.count {
            self.cardIndex = cardIndex + 1
        } else {
            self.cardIndex = 0
        }
    }
}

extension Countdown: Identifiable { }

extension Countdown: Hashable {
    public static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
