//
//  Card+Layout.swift
//  CountdownData
//
//  Created by Joe Rupertus on 12/29/24.
//

import Foundation
import SwiftUI

extension Card {
    
    public enum Layout: Codable, Equatable {
        case standard(titleAlignment: Alignment, titleSize: Double, numberAlignment: Alignment, numberSize: Double, showDate: Bool)
        
        public static let basic = Self.standard(titleAlignment: .leading, titleSize: 1.0, numberAlignment: .trailing, numberSize: 1.0, showDate: true)
    }
    
    public enum LayoutType: Int, Codable, CaseIterable {
        case standard
    }
    
    public enum Alignment: Int, Codable, CaseIterable {
        case leading
        case center
        case trailing
        
        public var name: String {
            switch self {
            case .leading: "Leading"
            case .center: "Center"
            case .trailing: "Trailing"
            }
        }
        
        public var imageName: String {
            switch self {
            case .leading: "text.alignleft"
            case .center: "text.aligncenter"
            case .trailing: "text.alignright"
            }
        }
        
        public var alignment: HorizontalAlignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
        
        public var oppositeEdge: Edge.Set {
            switch self {
            case .leading: .trailing
            case .center: Edge.Set()
            case .trailing: .leading
            }
        }
    }
}
