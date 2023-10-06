//
//  Countdown+Background.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import Foundation
import SwiftUI

extension Countdown {
    
    public enum Background {
        
        case photo(_ photo: UIImage)
        case gradient(_ colors: [Color])
        
        var data: BackgroundData? {
            switch self {
            case .photo(let photo):
                if let data = photo.pngData() {
                    return .photo(data)
                }
            case .gradient(let colors):
                return .gradient(colors)
            }
            return nil
        }
    }
    
    public enum BackgroundData: Codable, Hashable {
        
        case photo(_ data: Data)
        case gradient(_ colors: [Color])
        
        public var background: Background? {
            switch self {
            case .photo(let data):
                if let photo = UIImage(data: data) {
                    return .photo(photo)
                }
            case .gradient(let colors):
                return .gradient(colors)
            }
            return nil
        }
    }
}
