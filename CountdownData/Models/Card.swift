//
//  File.swift
//  
//
//  Created by Joe Rupertus on 10/5/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final public class Card {
    
    private var backgroundData: BackgroundData?
    public var background: Background? {
        backgroundData?.background
    }
    
    private var _tint: [Double]
    public var tint: Color {
        get { Color(rgb: _tint) }
        set { _tint = newValue.rgb }
    }
    
    public var textStyle: TextStyle
    
    public init() {
        self._tint = Color.gray.rgb
        self.textStyle = TextStyle.serif
    }
    
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
