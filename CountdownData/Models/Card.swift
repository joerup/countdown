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
    
    @Attribute(.externalStorage) public private(set) var background: Data?
    public var backgroundTransforms: BackgroundTransforms?
    
    private var backgroundRGB: RGBColor?
    public var backgroundColor: Color? {
        get { if let backgroundRGB { Color(rgb: backgroundRGB) } else { nil } }
        set { self.backgroundRGB = newValue?.rgb }
    }
    
    public var backgroundFade: Double = 0.4
    public var backgroundBlur: Double = 0
    public var backgroundBrightness: Double = 0
    public var backgroundSaturation: Double = 1.0
    public var backgroundContrast: Double = 1.0
    
    private var tint: RGBColor = Color.white.rgb
    public var textColor: Color {
        get { Color(rgb: tint) }
        set { self.tint = newValue.rgb }
    }
    
    public var textStyle: TextStyle = TextStyle.standard
    public var textWeight: Int = Font.Weight.medium.rawValue
    public var textOpacity: Double = 1.0
    public var textShadow: Double = 0
    
    public var titleSize: Double = 1.0
    public var numberSize: Double = 1.0
    
    public init() { }
    
    public init(from instance: CountdownInstance) {
        self.tint = instance.tint
        self.textStyle = instance.textStyle
        self.textWeight = instance.textWeight
        self.textOpacity = instance.textOpacity
        self.textShadow = instance.textShadow
        self.titleSize = instance.titleSize
        self.numberSize = instance.numberSize
        self.background = instance.background
        self.backgroundTransforms = instance.backgroundTransforms
        self.backgroundID = instance.backgroundID
        self.backgroundRGB = instance.backgroundRGB
        self.backgroundFade = instance.backgroundFade
        self.backgroundBlur = instance.backgroundBlur
        self.backgroundBrightness = instance.backgroundBrightness
        self.backgroundSaturation = instance.backgroundSaturation
        self.backgroundContrast = instance.backgroundContrast
        self.backgroundData = instance.backgroundData
        self.backgroundIconData = instance.backgroundIconData
    }
    public func match(_ instance: CountdownInstance) {
        self.tint = instance.tint
        self.textStyle = instance.textStyle
        self.textWeight = instance.textWeight
        self.textOpacity = instance.textOpacity
        self.textShadow = instance.textShadow
        self.titleSize = instance.titleSize
        self.numberSize = instance.numberSize
        self.background = instance.background
        self.backgroundTransforms = instance.backgroundTransforms
        self.backgroundID = instance.backgroundID
        self.backgroundRGB = instance.backgroundRGB
        self.backgroundFade = instance.backgroundFade
        self.backgroundBlur = instance.backgroundBlur
        self.backgroundBrightness = instance.backgroundBrightness
        self.backgroundSaturation = instance.backgroundSaturation
        self.backgroundContrast = instance.backgroundContrast
        self.backgroundData = instance.backgroundData
        self.backgroundIconData = instance.backgroundIconData
    }
    
    public func setBackground(_ data: Data?, transforms: Card.BackgroundTransforms? = nil) {
        self.background = data
        self.backgroundTransforms = transforms
        self.backgroundID = UUID()
    }
    public func getBackground() async -> Background? {
        return await Background(id: backgroundID, imageData: background, transforms: backgroundTransforms)
    }
    
    /* DEPRECATED */
    @Attribute(.externalStorage) public private(set) var backgroundData: BackgroundData?
    @Attribute(.externalStorage) public private(set) var backgroundIconData: BackgroundData?
    func removeOldBackgrounds() {
        backgroundData = nil
        backgroundIconData = nil
    }
    /* ---------- */
}

extension Card: Equatable, Hashable {
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
