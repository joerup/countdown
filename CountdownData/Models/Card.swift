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
    
    @Attribute private var _tint: [Double] = [255,255,255]
    @Transient public var tint: Color {
        get { Color(rgb: _tint) }
        set { _tint = newValue.rgb }
    }
    
    @Attribute(.externalStorage) private var backgroundData: BackgroundData?
    @Transient public var background: Background = .gradient([.black])
    
    public init() {
        self.background = .gradient([.white, .mint])
        self.backgroundData = background.data
    }
    
    public func loadBackground() async {
        if let background = backgroundData?.background {
            self.background = background
        }
    }
    public func setBackground(_ background: Background) {
        if let data = background.data {
            self.backgroundData = data
            self.background = background
        }
    }
}
