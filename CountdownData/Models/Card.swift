//
//  Card.swift
//
//
//  Created by Joe Rupertus on 10/5/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public final class Card {
    
    public var countdown: Countdown?
    
    @Attribute(.externalStorage) private var backgroundData: BackgroundData?
    public var background: Background? {
        if let background = countdown?.currentBackground {
            return background
        }
        countdown?.currentBackground = backgroundData?.background
        return countdown?.currentBackground
    }
    
    private var tint: [Double] = [0.8,0.8,0.8]
    public var tintColor: Color {
        return Color(rgb: tint)
    }
    
    public var textStyle: TextStyle = TextStyle.serif
    public var textShadow: Double = 0
    
    public init() { }
    
    public func setBackground(_ background: Background) {
        self.backgroundData = background.data
        countdown?.currentBackground = background
    }
    public func setTintColor(_ color: Color) {
        self.tint = color.rgb
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
