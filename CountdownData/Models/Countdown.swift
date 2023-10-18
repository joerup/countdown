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
    
    @Attribute private var _destination: Data?
    @Transient public var destination: Destination {
        get {
            guard let rawDestination = _destination, let destination = try? JSONDecoder().decode(Destination.self, from: rawDestination) else { return .now }
            return destination
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
        let components = componentsRemaining
        guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return 0 }
        return day + (hour == 0 && minute == 0 && second == 0 ? 0 : 1)
    }
    public var componentsRemaining: DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: .now.advanced(by: timeRemaining + 1))
    }
    
    @Relationship(deleteRule: .cascade) public var cards: [Card] = []
    
    public var card: Card? {
        return cards.first
    }
    
    @Transient public var cardIndex: Int?
    @Transient public var cardTimer: Timer?
    
    public var cardCycleEnabled: Bool = false
    public var cardCycleDuration: Double = 7.0
    
    public init(name: String, destination: Destination) {
        self.id = name
        self.name = name
        self.cards = [Card()]
        self.destination = destination
    }
    public init(name: String, date: Date) {
        self.id = name
        self.name = name
        self.cards = [Card()]
        self.destination = .date(date)
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
