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
public final class Card {
    
    public var countdown: Countdown?
    public private(set) var backgroundID: UUID = UUID()
    
    @Attribute(.externalStorage) public private(set) var backgroundData: BackgroundData?
    @Attribute(.externalStorage) public private(set) var backgroundIconData: BackgroundData?
    
    private var backgroundRGB: RGBColor = Color.defaultColor.rgb
    public var backgroundColor: Color {
        get { Color(rgb: backgroundRGB) }
        set { self.backgroundRGB = newValue.rgb }
    }
    
    public var backgroundFade: Double = 0
    public var backgroundBlur: Double = 0
    
    private var tint: RGBColor = Color.white.rgb
    public var tintColor: Color {
        get { Color(rgb: tint) }
        set { self.tint = newValue.rgb }
    }
    
    public var textStyle: TextStyle = TextStyle.standard
    public var textWeight: Int = Font.Weight.medium.rawValue
    public var textShadow: Double = 0
    
    public init() { }
    
    public init(from instance: CountdownInstance) {
        self.tint = instance.tint
        self.textStyle = instance.textStyle
        self.textWeight = instance.textWeight
        self.textShadow = instance.textShadow
        self.backgroundRGB = instance.backgroundRGB
        self.backgroundFade = instance.backgroundFade
        self.backgroundBlur = instance.backgroundBlur
        self.backgroundData = instance.backgroundData
        self.backgroundIconData = instance.backgroundIconData
        self.backgroundID = instance.backgroundID
    }
    public func match(_ instance: CountdownInstance) {
        self.tint = instance.tint
        self.textStyle = instance.textStyle
        self.textWeight = instance.textWeight
        self.textShadow = instance.textShadow
        self.backgroundRGB = instance.backgroundRGB
        self.backgroundFade = instance.backgroundFade
        self.backgroundBlur = instance.backgroundBlur
        self.backgroundData = instance.backgroundData
        self.backgroundIconData = instance.backgroundIconData
        self.backgroundID = instance.backgroundID
    }
    
    public func loadingBackground() {
        countdown?.currentBackground = .loading
    }
    public func setBackground(_ data: BackgroundData?) {
        self.backgroundData = data
        self.backgroundIconData = data?.icon
        self.backgroundID = UUID()
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
