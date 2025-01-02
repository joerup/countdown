//
//  CountdownInstance.swift
//  CountdownData
//
//  Created by Joe Rupertus on 7/6/24.
//

import Foundation
import SwiftData
import SwiftUI

public final class CountdownInstance: Codable {
    
    public private(set) var timestamp: Date
    
    public private(set) var countdownID: UUID
    public private(set) var name: String
    public private(set) var displayName: String
    public private(set) var type: EventType
    public private(set) var occasion: Occasion
    
    private(set) var tint: RGBColor
    public var tintColor: Color { Color(rgb: tint) }
    public private(set) var textStyle: Card.TextStyle
    public private(set) var textWeight: Int
    public private(set) var textOpacity: Double
    public private(set) var textShadow: Double
    
    public private(set) var titleSize: Double
    public private(set) var numberSize: Double
    
    private(set) var backgroundRGB: RGBColor?
    public var backgroundColor: Color? { if let backgroundRGB { Color(rgb: backgroundRGB) } else { nil } }
    public private(set) var backgroundFade: Double
    public private(set) var backgroundBlur: Double
    public private(set) var backgroundBrightness: Double
    public private(set) var backgroundSaturation: Double
    public private(set) var backgroundContrast: Double
    
    public private(set) var backgroundData: Card.BackgroundData?
    public private(set) var backgroundIconData: Card.BackgroundData?
    public private(set) var backgroundID: UUID
    public private(set) var currentBackgroundIcon: Card.Background?
    
    public private(set) var backgroundTransformSquare: Card.ImageTransform?
    public private(set) var backgroundTransformFull: Card.ImageTransform?
    
    public var date: Date {
        occasion.date
    }
    public var dateString: String {
        "\(date.dateString)\(occasion.includeTime ? " \(date.timeString)" : "")"
    }
    public var daysRemaining: Int {
        date.daysRemaining(relativeTo: timestamp)
    }
    public var timeRemaining: Date.TimeRemaining {
        date.timeRemaining(relativeTo: timestamp)
    }
    
    public init(from countdown: Countdown) {
        self.timestamp = .now
        self.countdownID = countdown.id
        self.name = countdown.name
        self.displayName = countdown.displayName
        self.type = countdown.type
        self.occasion = countdown.occasion
        self.tint = countdown.currentTintColor.rgb
        self.textStyle = countdown.currentTextStyle
        self.textWeight = countdown.currentTextWeight
        self.textOpacity = countdown.currentTextOpacity
        self.textShadow = countdown.currentTextShadow
        self.titleSize = countdown.currentTitleSize
        self.numberSize = countdown.currentNumberSize
        self.backgroundRGB = countdown.currentBackgroundColor?.rgb
        self.backgroundFade = countdown.currentBackgroundFade
        self.backgroundBlur = countdown.currentBackgroundBlur
        self.backgroundBrightness = countdown.currentBackgroundBrightness
        self.backgroundSaturation = countdown.currentBackgroundSaturation
        self.backgroundContrast = countdown.currentBackgroundContrast
        self.backgroundData = countdown.card?.backgroundData
        self.backgroundIconData = countdown.card?.backgroundIconData
        self.backgroundID = countdown.card?.backgroundID ?? UUID()
        self.backgroundTransformSquare = countdown.card?.backgroundTransformSquare
        self.backgroundTransformFull = countdown.card?.backgroundTransformFull
    }
    public func setBackground(_ data: Card.BackgroundData?) {
        self.backgroundData = data
        self.backgroundIconData = data?.icon(transform: backgroundTransformSquare)
    }
    public func loadCard() async {
        currentBackgroundIcon = .loading
        currentBackgroundIcon = await backgroundIconData?.background()
    }
    
    enum CodingKeys: CodingKey {
        case timestamp, countdownID, name, displayName, type, occasion,
             tint, textStyle, textWeight, textOpacity, textShadow, titleSize, numberSize,
             backgroundColor, backgroundFade, backgroundBlur, backgroundSaturation, backgroundBrightness, backgroundContrast,
             backgroundData, backgroundIconData, backgroundID, backgroundTransformSquare, backgroundTransformFull
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        countdownID = try container.decode(UUID.self, forKey: .countdownID)
        name = try container.decode(String.self, forKey: .name)
        displayName = try container.decode(String.self, forKey: .displayName)
        type = try container.decode(EventType.self, forKey: .type)
        occasion = try container.decode(Occasion.self, forKey: .occasion)
        tint = (try? container.decode(RGBColor.self, forKey: .tint)) ?? [0,0,0]
        textStyle = (try? container.decode(Card.TextStyle.self, forKey: .textStyle)) ?? .standard
        textWeight = (try? container.decode(Int.self, forKey: .textWeight)) ?? Font.Weight.medium.rawValue
        textOpacity = (try? container.decode(Double.self, forKey: .textOpacity)) ?? 1.0
        textShadow = (try? container.decode(Double.self, forKey: .textShadow)) ?? 0
        titleSize = (try? container.decode(Double.self, forKey: .titleSize)) ?? 1.0
        numberSize = (try? container.decode(Double.self, forKey: .numberSize)) ?? 1.0
        backgroundRGB = try? container.decode(RGBColor.self, forKey: .backgroundColor)
        backgroundFade = (try? container.decode(Double.self, forKey: .backgroundFade)) ?? 0.4
        backgroundBlur = (try? container.decode(Double.self, forKey: .backgroundBlur)) ?? 0
        backgroundBrightness = (try? container.decode(Double.self, forKey: .backgroundBrightness)) ?? 0
        backgroundSaturation = (try? container.decode(Double.self, forKey: .backgroundSaturation)) ?? 1.0
        backgroundContrast = (try? container.decode(Double.self, forKey: .backgroundContrast)) ?? 1.0
        backgroundData = try? container.decode(Card.BackgroundData.self, forKey: .backgroundData)
        backgroundIconData = try? container.decode(Card.BackgroundData.self, forKey: .backgroundIconData)
        backgroundID = (try? container.decode(UUID.self, forKey: .backgroundID)) ?? UUID()
        backgroundTransformSquare = try? container.decode(Card.ImageTransform.self, forKey: .backgroundTransformSquare)
        backgroundTransformFull = try? container.decode(Card.ImageTransform.self, forKey: .backgroundTransformFull)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(countdownID, forKey: .countdownID)
        try container.encode(name, forKey: .name)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(type, forKey: .type)
        try container.encode(occasion, forKey: .occasion)
        try container.encode(tint, forKey: .tint)
        try container.encode(textStyle, forKey: .textStyle)
        try container.encode(textWeight, forKey: .textWeight)
        try container.encode(textOpacity, forKey: .textOpacity)
        try container.encode(textShadow, forKey: .textShadow)
        try container.encode(titleSize, forKey: .titleSize)
        try container.encode(numberSize, forKey: .numberSize)
        try container.encode(backgroundRGB, forKey: .backgroundColor)
        try container.encode(backgroundFade, forKey: .backgroundFade)
        try container.encode(backgroundBlur, forKey: .backgroundBlur)
        try container.encode(backgroundSaturation, forKey: .backgroundSaturation)
        try container.encode(backgroundBrightness, forKey: .backgroundBrightness)
        try container.encode(backgroundContrast, forKey: .backgroundContrast)
        if case .photoLink(_) = backgroundData {
            try container.encode(backgroundData, forKey: .backgroundData)
            try container.encode(backgroundIconData, forKey: .backgroundIconData)
        }
        try container.encode(backgroundID, forKey: .backgroundID)
        try container.encode(backgroundTransformFull, forKey: .backgroundTransformFull)
        try container.encode(backgroundTransformSquare, forKey: .backgroundTransformSquare)
    }
    
    // Compare all states of this instance to a given countdown
    public func compareTo(countdown: Countdown) -> Bool {
        self.countdownID == countdown.id &&
        self.name == countdown.name &&
        self.displayName == countdown.displayName &&
        self.type == countdown.type &&
        self.occasion == countdown.occasion &&
        self.tint == countdown.currentTintColor.rgb &&
        self.textStyle == countdown.currentTextStyle &&
        self.textWeight == countdown.currentTextWeight &&
        self.textShadow == countdown.currentTextShadow &&
        self.titleSize == countdown.card?.titleSize &&
        self.numberSize == countdown.card?.numberSize &&
        self.backgroundRGB == countdown.currentBackgroundColor?.rgb &&
        self.backgroundFade == countdown.currentBackgroundFade &&
        self.backgroundBlur == countdown.currentBackgroundBlur &&
        self.backgroundSaturation == countdown.currentBackgroundSaturation &&
        self.backgroundBrightness == countdown.currentBackgroundBrightness &&
        self.backgroundContrast == countdown.currentBackgroundContrast &&
        self.backgroundID == countdown.card?.backgroundID &&
        self.backgroundTransformFull == countdown.card?.backgroundTransformFull &&
        self.backgroundTransformSquare == countdown.card?.backgroundTransformSquare
    }
    
    // Create an encoding for this instance
    public func toEncodingURL() -> URL? {
        guard let countdownData = try? JSONEncoder().encode(self) else { return nil }
        let countdownString = countdownData.base64EncodedString()
        guard var components = URLComponents(string:"data:,") else { return nil }
        components.queryItems = [URLQueryItem(name: "raw", value: countdownString)]
        
        return components.url
    }
    
    // Decode the instance from an encoding
    public static func fromEncodingURL(_ url: URL) -> CountdownInstance? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let rawItem = queryItems.first,
              let base64String = rawItem.value,
              let data = Data(base64Encoded: base64String),
              let instance = try? JSONDecoder().decode(CountdownInstance.self, from: data)
        else {
            return nil
        }
        
        return instance
    }
}
