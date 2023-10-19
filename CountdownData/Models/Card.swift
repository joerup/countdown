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
    
    private var _tint: [Double] = Color.gray.rgb
    public var tint: Color {
        get { Color(rgb: _tint) }
        set { _tint = newValue.rgb }
    }
    
    public var textStyle: TextStyle = TextStyle.serif
    
    public init() { }
    
    public func setBackground(_ background: Background) {
        self.backgroundData = background.data
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
