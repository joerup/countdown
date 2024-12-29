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
    
    
    // MARK: - Counter
    
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
    public var isPastDay: Bool {
        return date.midnight < .now.midnight
    }
    public var isFutureDay: Bool {
        return date.midnight > .now.midnight
    }
    public var under24Hr: Bool {
        return Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now >= date
    }
    
    @Transient public var daysRemaining: Int = 0
    @Transient public var timeRemaining: Date.TimeRemaining = .none
    
    
    // MARK: - Cards
    
    @Relationship(deleteRule: .cascade, inverse: \Card.countdown) public var cards: [Card]?
    public var card: Card? {
        return cards?.first
    }
    
    @Transient public var currentBackground: Card.Background?
    @Transient public var currentBackgroundIcon: Card.Background?
    @Transient public var currentBackgroundID: UUID = UUID()
    
    public var currentBackgroundColor: Color {
        return card?.backgroundColor ?? .white
    }
    public var currentBackgroundFade: Double {
        return card?.backgroundFade ?? 0
    }
    public var currentBackgroundBlur: Double {
        return card?.backgroundBlur ?? 0
    }
    
    public var currentLayout: Card.Layout {
        return card?.layout ?? .basic
    }
    
    public var currentTintColor: Color {
        return card?.tintColor ?? .white
    }
    public var currentTextStyle: Card.TextStyle {
        return card?.textStyle ?? .standard
    }
    public var currentTextWeight: Int {
        return card?.textWeight ?? Font.Weight.medium.rawValue
    }
    public var currentTextShadow: Double {
        return card?.textShadow ?? 0
    }
    
    // MARK: - Configuration
    
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
    
    public init(from instance: CountdownInstance) {
        self.id = instance.countdownID
        self.name = instance.name
        self.displayName = instance.displayName
        self.type = instance.type
        self.occasion = instance.occasion
        self.currentBackgroundID = instance.backgroundID
        self.cards = [Card(from: instance)]
    }
    public func match(_ instance: CountdownInstance) {
        self.id = instance.countdownID
        self.name = instance.name
        self.displayName = instance.displayName
        self.type = instance.type
        self.occasion = instance.occasion
        self.currentBackgroundID = instance.backgroundID
        self.card?.match(instance)
    }
    public func compareTo(countdown: Countdown) -> Bool {
        self.id == countdown.id &&
        self.name == countdown.name &&
        self.displayName == countdown.displayName &&
        self.type == countdown.type &&
        self.occasion == countdown.occasion &&
        self.currentTintColor.rgb == countdown.currentTintColor.rgb &&
        self.currentTextStyle == countdown.currentTextStyle &&
        self.currentTextShadow == countdown.currentTextShadow &&
        self.currentBackgroundColor == countdown.currentBackgroundColor &&
        self.currentBackgroundFade == countdown.currentBackgroundFade &&
        self.card?.backgroundID == countdown.card?.backgroundID &&
        self.card?.layout == countdown.card?.layout
    }
    
    public func loadCards() async {
        
        // Change photo URL to image data
        await card?.updateLink()
        
        // Match backgrounds and background icons
        for card in (cards ?? []) {
            if card.backgroundData != nil && card.backgroundIconData == nil {
                card.setBackground(card.backgroundData)
            }
        }
        
        // Fetch countdown backgrounds
        if let card, currentBackgroundID != card.backgroundID {
            currentBackground = .loading
            currentBackgroundIcon = .loading
            currentBackground = await card.getBackground()
            currentBackgroundIcon = await card.getBackgroundIcon()
            currentBackgroundID = card.backgroundID
        }
        
        // Add cards to empty countdowns
        if let cards {
            if cards.isEmpty {
                self.cards?.append(Card())
            }
        } else {
            cards = [Card()]
        }
    }
    
    // Tick one second
    internal func tick() {
        if timeRemaining.second > 0 {
            self.timeRemaining.second -= 1
        }
        else if timeRemaining.minute > 0 {
            self.timeRemaining.minute -= 1
            self.timeRemaining.second = 59
        }
        else if timeRemaining.hour > 0 {
            self.timeRemaining.hour -= 1
            self.timeRemaining.minute = 59
            self.timeRemaining.second = 59
        }
        else if timeRemaining.day > 0 {
            self.daysRemaining -= 1
            self.timeRemaining.day -= 1
            self.timeRemaining.hour = 23
            self.timeRemaining.minute = 59
            self.timeRemaining.second = 59
        }
    }
    
    
    // MARK: - Other
    
    // Create a link to open this countdown via id
    public func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = "countdown"
        components.host = "open"
        components.queryItems = [URLQueryItem(name: "id", value: id.uuidString)]
        
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
