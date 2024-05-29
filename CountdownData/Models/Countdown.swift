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
public final class Countdown: Codable {
    
    public var id: UUID = UUID()
    public var name: String = ""
    public var displayName: String = ""
    public var type: EventType = EventType.custom
    public var occasion: Occasion = Occasion.now
    
    public var date: Date {
        occasion.date
    }
    public var dateString: String {
        "\(date.dateString)\(occasion.includeTime ? " \(date.timeString)" : "")"
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
        self.occasion = occasion
        self.cards = [Card()]
    }
    public init(name: String, date: Date) {
        self.id = UUID()
        self.name = name
        self.displayName = name
        self.type = .custom
        self.occasion = .now
        self.cards = [Card()]
    }
    
    enum CodingKeys: CodingKey {
        case id, name, displayName, type, occasion, cards
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        displayName = try container.decode(String.self, forKey: .displayName)
        type = try container.decode(EventType.self, forKey: .type)
        occasion = try container.decode(Occasion.self, forKey: .occasion)
        cards = try container.decode([Card].self, forKey: .cards)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(type, forKey: .type)
        try container.encode(occasion, forKey: .occasion)
        try container.encode(cards, forKey: .cards)
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
    
    public func createURL() -> URL? {
        guard let countdownData = try? JSONEncoder().encode(self) else { return nil }
        
        let countdownString = countdownData.base64EncodedString()
        var components = URLComponents()
        components.scheme = "com.rupertusapps.Countdown"
        components.host = "countdown"
        components.queryItems = [URLQueryItem(name: "data", value: countdownString)]
        
        return components.url
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
