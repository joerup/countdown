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
    
    @Attribute(.externalStorage) public var backgroundData: BackgroundData?
    
    private var tint: [Double] = Color.white.rgb
    public var tintColor: Color {
        return Color(rgb: tint)
    }
    
    public var textStyle: TextStyle = TextStyle.standard
    public var textShadow: Double = 0
    
    public init() { }
    
    public func loadingBackground() {
        countdown?.currentBackground = .loading
    }
    public func setBackground(_ data: BackgroundData?) {
        self.backgroundData = data
    }
    public func getBackground() async -> Background? {
        return await backgroundData?.background()
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
