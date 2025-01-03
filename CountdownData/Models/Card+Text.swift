//
//  Card+TextStyle.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/14/23.
//

import Foundation
import SwiftUI

extension Card {
    
    public enum TextStyle: Int, Codable, Identifiable, CaseIterable {
        case standard
        case round
        case serif
        case mono
        case expanded
        case compressed
        
        public var design: Font.Design {
            switch self {
            case .serif:
                return .serif
            case .mono:
                return .monospaced
            case .round:
                return .rounded
            default:
                return .default
            }
        }
        
        public var secondaryDesign: Font.Design {
            switch self {
            case .serif:
                return .serif
            case .round:
                return .rounded
            default:
                return .default
            }
        }
        
        public var width: Font.Width {
            switch self {
            case .expanded:
                return .expanded
            case .compressed:
                return .condensed
            default:
                return .standard
            }
        }
        
        public var id: Self {
            return self
        }
    }
}
