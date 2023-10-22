//
//  Other.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import Foundation
import SwiftUI
import UIKit
import EventKit


public extension GeometryProxy {
    
    var totalSize: CGSize {
        CGSize(width: size.width + safeAreaInsets.leading + safeAreaInsets.trailing, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
    }
}

public extension Int {
    
    var ordinalString: String {
        if self == -1 {
            return "last"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: self) ?? String(self)
    }
}

extension Calendar.Identifier {

    public init(_ string: String) {
        switch string {
        case "gregorian": self = .gregorian
        case "hebrew": self = .hebrew
        case "chinese": self = .chinese
        case "islamic": self = .islamicCivil
        case "hindu": self = .indian
        default: self = .iso8601
        }
    }
    
    public var name: String {
        return String("\(self)").capitalized
    }
}
