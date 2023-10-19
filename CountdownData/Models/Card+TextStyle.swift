//
//  Card+TextStyle.swift
//
//
//  Created by Joe Rupertus on 10/14/23.
//

import Foundation
import SwiftUI

extension Card {
    
    public enum TextStyle: Int, Codable, Identifiable, CaseIterable {
        case serif
        case mono
        case round
        
        public var design: Font.Design {
            switch self {
            case .serif:
                return .serif
            case .mono:
                return .monospaced
            case .round:
                return .rounded
            }
        }
        
        public var weight: Font.Weight {
            switch self {
            case .serif:
                return .heavy
            case .mono:
                return .bold
            case .round:
                return .heavy
            }
        }
        
        public var width: Font.Width {
            switch self {
            case .serif, .mono, .round:
                return .standard
            }
        }
        
        public var id: Self {
            return self
        }
    }
}
