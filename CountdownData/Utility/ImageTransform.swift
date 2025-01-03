//
//  ImageTransform.swift
//  CountdownData
//
//  Created by Joe Rupertus on 1/3/25.
//

import Foundation

public struct ImageTransform: Codable, Equatable, Hashable {
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    public var offset: CGSize {
        return .init(width: offsetX, height: offsetY)
    }
    
    public var scale: CGFloat = 1.0
    
    public init() { }
    
    public init(offset: CGSize, scale: CGFloat) {
        self.offsetX = offset.width
        self.offsetY = offset.height
        self.scale = scale
    }
}
