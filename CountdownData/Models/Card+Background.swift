//
//  Card+Background.swift
//  
//
//  Created by Joe Rupertus on 10/5/23.
//

import Foundation
import SwiftUI

extension Card {
    
    public enum Background {
        
        case photo(_ photo: UIImage)
        case gradient(_ colors: [Color])
        
        var data: BackgroundData? {
            switch self {
            case .photo(let photo):
                if let data = compress(photo) {
                    return .photo(data)
                }
            case .gradient(let colors):
                return .gradient(colors)
            }
            return nil
        }
        
        private func compress(_ photo: UIImage, compressionQuality: Double = 1.0) -> Data? {
            if let data = photo.jpegData(compressionQuality: compressionQuality) {
                if data.count >= 1000000 {
                    return compress(photo, compressionQuality: compressionQuality*0.8)
                } else {
                    return data
                }
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

