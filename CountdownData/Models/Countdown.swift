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
    public var dateString: String {
        date.dateString
    }
    
    // MARK: - Counter
    
    @Transient public var daysRemaining: Int = 0
    @Transient public var timeRemaining: Date.TimeRemaining = .zero
    
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
    
    
    // MARK: - Cards
    
    @Relationship(deleteRule: .cascade, inverse: \Card.countdown) public var cards: [Card]?
    public var card: Card? {
        return cards?.first
    }
    
    @Transient public var currentBackground: Card.Background?
    
    public var currentBackgroundColor: Color? {
        return card?.backgroundColor
    }
    public var currentBackgroundFade: Double {
        return card?.backgroundFade ?? 0
    }
    public var currentBackgroundBlur: Double {
        return card?.backgroundBlur ?? 0
    }
    public var currentBackgroundBrightness: Double {
        return card?.backgroundBrightness ?? 0
    }
    public var currentBackgroundSaturation: Double {
        return card?.backgroundSaturation ?? 1.0
    }
    public var currentBackgroundContrast: Double {
        return card?.backgroundContrast ?? 1.0
    }
    
    public var currentTextColor: Color {
        return card?.textColor ?? .white
    }
    public var currentTextStyle: Card.TextStyle {
        return card?.textStyle ?? .standard
    }
    public var currentTextWeight: Int {
        return card?.textWeight ?? Font.Weight.medium.rawValue
    }
    public var currentTextOpacity: Double {
        return card?.textOpacity ?? 1.0
    }
    public var currentTextShadow: Double {
        return card?.textShadow ?? 0
    }
    public var currentTitleSize: Double {
        return card?.titleSize ?? 1.0
    }
    public var currentNumberSize: Double {
        return card?.numberSize ?? 1.0
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
        self.cards = [Card(from: instance)]
    }
    public func match(_ instance: CountdownInstance) {
        self.id = instance.countdownID
        self.name = instance.name
        self.displayName = instance.displayName
        self.type = instance.type
        self.occasion = instance.occasion
        self.card?.match(instance)
    }
    public func compareTo(countdown: Countdown) -> Bool {
        self.id == countdown.id &&
        self.name == countdown.name &&
        self.displayName == countdown.displayName &&
        self.type == countdown.type &&
        self.occasion == countdown.occasion &&
        self.currentTextColor.rgb == countdown.currentTextColor.rgb &&
        self.currentTextStyle == countdown.currentTextStyle &&
        self.currentTextOpacity == countdown.currentTextOpacity &&
        self.currentTextShadow == countdown.currentTextShadow &&
        self.currentBackgroundColor == countdown.currentBackgroundColor &&
        self.currentBackgroundFade == countdown.currentBackgroundFade &&
        self.currentBackgroundBrightness == countdown.currentBackgroundBrightness &&
        self.currentBackgroundSaturation == countdown.currentBackgroundSaturation &&
        self.currentBackgroundContrast == countdown.currentBackgroundContrast &&
        self.card?.backgroundID == countdown.card?.backgroundID 
    }
    
    public func loadCards() async {
        
        // Update old backgrounds if they still exist
        await card?.updateOldBackgrounds()
        
        // Match backgrounds and background icons
//        for card in (cards ?? []) {
//            if let background = card.background {
//                card.setBackground(background)
//            }
//        }
        
        // Fetch current background
        if let card, currentBackground?.id != card.backgroundID {
            currentBackground = await card.getBackground()
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
