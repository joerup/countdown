//
//  Card.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/5/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public final class Card: Codable {
    
    public var countdown: Countdown?
    
    @Attribute(.externalStorage) public private(set) var backgroundData: BackgroundData?
    @Attribute(.externalStorage) public private(set) var backgroundIconData: BackgroundData?
    
    private var tint: [Double] = Color.white.rgb
    public var tintColor: Color {
        get { Color(rgb: tint) }
        set { self.tint = newValue.rgb }
    }
    
    public var textStyle: TextStyle = TextStyle.standard
    
    public var textShadow: Double = 0
    
    public init() { }
    
    enum CodingKeys: CodingKey {
        case tint, textStyle, textShadow, backgroundData, backgroundIconData
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tint = try container.decode([Double].self, forKey: .tint)
        textStyle = try container.decode(TextStyle.self, forKey: .textStyle)
        textShadow = try container.decode(Double.self, forKey: .textShadow)
        backgroundData = try? container.decode(BackgroundData.self, forKey: .backgroundData)
        backgroundIconData = try? container.decode(BackgroundData.self, forKey: .backgroundIconData)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tint, forKey: .tint)
        try container.encode(textStyle, forKey: .textStyle)
        try container.encode(textShadow, forKey: .textShadow)
        if case .photoLink(_) = backgroundData {
            try container.encode(backgroundData, forKey: .backgroundData)
            try container.encode(backgroundIconData, forKey: .backgroundIconData)
        }
    }
    
    public func loadingBackground() {
        countdown?.currentBackground = .loading
    }
    public func setBackground(_ data: BackgroundData?) {
        self.backgroundData = data
        self.backgroundIconData = data?.icon
    }
    public func getBackground() async -> Background? {
        return await backgroundData?.background()
    }
    public func getBackgroundIcon() async -> Background? {
        return await backgroundIconData?.background()
    }
}

extension Card: Equatable, Hashable {
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
