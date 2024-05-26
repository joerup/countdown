//
//  Countdown.swift
//  CountdownData
//
//  Created by Joe Rupertus on 5/6/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public final class Countdown {
    
    public var id: UUID = UUID()
    public var name: String = ""
    public var displayName: String = ""
    public var type: EventType = EventType.custom
    
    public var occasion: Occasion = Occasion.now
    
    public var date: Date {
        occasion.date
    }
    
    public var isActive: Bool {
        return date > .now
    }
    public var isComplete: Bool {
        return !isActive
    }
    public var isToday: Bool {
        return date.midnight == .now.midnight
    }
    public var wasToday: Bool {
        return isToday && isComplete
    }
    public var isPastDay: Bool {
        return date.midnight < .now.midnight
    }
    public var isFutureDay: Bool {
        return date.midnight > .now.midnight
    }
    public var under24Hr: Bool {
        return Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now >= date
    }
    
    @Relationship(deleteRule: .cascade, inverse: \Card.countdown) public var cards: [Card]?
    @Transient public var currentBackground: Card.Background? = nil
    public var card: Card? {
        return cards?.first
    }
    @Transient public var cardIndex: Int?
    @Transient public var cardTimer: Timer?
    public var cardCycleEnabled: Bool = false
    public var cardCycleDuration: Double = 7.0
    
    public init(name: String, displayName: String, type: EventType, occasion: Occasion) {
        self.id = UUID()
        self.name = name
        self.displayName = displayName
        self.type = type
        self.cards = [Card()]
        self.occasion = occasion
    }
    public init(name: String, date: Date) {
        self.id = UUID()
        self.name = name
        self.displayName = name
        self.type = .custom
        self.cards = [Card()]
        self.occasion = .now
    }
    
    public func addCard(_ card: Card) {
        cards?.append(card)
    }
    public func removeCard(at index: Int) {
        cards?.remove(at: index)
    }
    
    public func startCardTimer() {
        cardTimer?.invalidate()
        guard let cards, cardCycleEnabled, cards.count > 1 else { return }
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
        guard let cards, let cardIndex else { return }
        if cardIndex+1 < cards.count {
            self.cardIndex = cardIndex + 1
        } else {
            self.cardIndex = 0
        }
    }
    
    public func fetchBackground() async {
        currentBackground = .loading
        currentBackground = await card?.getBackground()
    }
}

extension Countdown: Identifiable, Equatable, Comparable, Hashable {
    
    public static func == (lhs: Countdown, rhs: Countdown) -> Bool {
        return lhs.id == rhs.id
    }
    public static func < (lhs: Countdown, rhs: Countdown) -> Bool {
        return lhs.date < rhs.date
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
