//
//  Font.swift
//  CountdownData
//
//  Created by Joe Rupertus on 12/28/24.
//

import SwiftUI

public extension Font.Weight {
    static let minimum: Int = 1
    static let maximum: Int = 9
    
    var rawValue: Int {
        switch self {
        case .ultraLight: return 1
        case .thin: return 2
        case .light: return 3
        case .regular: return 4
        case .medium: return 5
        case .semibold: return 6
        case .bold: return 7
        case .heavy: return 8
        case .black: return 9
        default: return 4 // Default to regular
        }
    }

    init(rawValue: Int) {
        switch rawValue {
        case 1: self = .ultraLight
        case 2: self = .thin
        case 3: self = .light
        case 4: self = .regular
        case 5: self = .medium
        case 6: self = .semibold
        case 7: self = .bold
        case 8: self = .heavy
        case 9: self = .black
        default: self = .regular
        }
    }
    
    func bolder() -> Font.Weight {
        let nextValue = min(self.rawValue + 1, Font.Weight.maximum)
        return Font.Weight(rawValue: nextValue)
    }
}
