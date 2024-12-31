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
        case standard(_ options: StandardOptions)
        case bottom(_ options: BottomOptions)
        case timer(_ options: TimerOptions)
        
        public static let basic = Self.standard(.init())
        
        public struct StandardOptions: Codable, Equatable {
            public var titleAlignment: Alignment = .leading
            public var titleSize: Double = 1.0
            public var showDate: Bool = true
            public var numberAlignment: Alignment = .trailing
            public var numberSize: Double = 1.0
            
            public init() { }
            
            public init(titleAlignment: Alignment, titleSize: Double, showDate: Bool, numberAlignment: Alignment, numberSize: Double) {
                self.titleAlignment = titleAlignment
                self.titleSize = titleSize
                self.numberAlignment = numberAlignment
                self.numberSize = numberSize
                self.showDate = showDate
            }
        }
        
        public struct BottomOptions: Codable, Equatable {
            public var alignment: Alignment = .center
            public var size: Double = 1.0
            public var showDate: Bool = false
            
            public init() { }
            
            public init(alignment: Alignment, size: Double, showDate: Bool) {
                self.alignment = alignment
                self.size = size
                self.showDate = showDate
            }
        }
        
        public struct TimerOptions: Codable, Equatable {
            public var titleAlignment: Alignment = .leading
            public var titleSize: Double = 1.0
            public var showDate: Bool = true
            public var numberAlignment: Alignment = .trailing
            public var numberSize: Double = 1.0
            
            public init() { }
            
            public init(titleAlignment: Alignment, titleSize: Double, showDate: Bool, numberAlignment: Alignment, numberSize: Double) {
                self.titleAlignment = titleAlignment
                self.titleSize = titleSize
                self.numberAlignment = numberAlignment
                self.numberSize = numberSize
                self.showDate = showDate
            }
        }
    }
    
    public enum LayoutType: Int, Codable, CaseIterable {
        case standard
        case bottom
        case timer
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
        
        public var horizontalAlignment: HorizontalAlignment {
            switch self {
            case .leading: .leading
            case .center: .center
            case .trailing: .trailing
            }
        }
        public var textAlignment: TextAlignment {
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
