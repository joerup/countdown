//
//  Countdown+DisplaySettings.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/21/23.
//

import Foundation
import SwiftUI

extension Countdown {
    
    public enum TextDesign: Int, CaseIterable, Codable, Identifiable {
        case regular
        case light
        case serif
        case monospace
        case condensed
        case compressed
        case expanded
        
        public func counterFont(size: CGFloat) -> Font {
            switch self {
            case .regular:
                .system(size: size, weight: .bold, design: .rounded)
            case .light:
                .system(size: size, weight: .medium, design: .rounded)
            case .serif:
                .system(size: size, weight: .bold, design: .serif)
            case .monospace:
                .system(size: size, weight: .bold, design: .monospaced)
            case .compressed, .condensed, .expanded:
                .system(size: size, weight: .bold)
            }
        }
        
        public func titleFont(size: CGFloat) -> Font {
            switch self {
            case .serif:
                .system(size: size, weight: .semibold, design: .serif)
            case .monospace:
                .system(size: size, weight: .semibold, design: .default)
            default:
                counterFont(size: size)
            }
        }
        
        public func fontWidth() -> Font.Width {
            switch self {
            case .condensed:
                return .condensed
            case .compressed:
                return .compressed
            case .expanded:
                return .expanded
            default:
                return .standard
            }
        }
        
        public var id: Self {
            return self
        }
    }
    
    public enum TextPosition: Int, CaseIterable, Codable, Identifiable {
        case top
        case center
        case bottom
        
        public var name: String {
            switch self {
            case .top:
                "Top"
            case .center:
                "Center"
            case .bottom:
                "Bottom"
            }
        }
        
        public var id: Self {
            return self
        }
    }
}
