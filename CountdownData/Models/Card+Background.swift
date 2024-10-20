//
//  Card+Background.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/5/23.
//

import Foundation
import SwiftUI

extension Card {
    
    public static let maxPhotoSize: Double = 750000
    public static let maxIconSize: Double = 50000
    
    public enum Background {
        case photo(_ photo: UIImage)
        case loading
        
//        public func size() -> Int {
//            switch self {
//            case .photo(let photo):
//                return photo.compressed(size: Card.maxPhotoSize)?.count ?? 0
//            default:
//                return 0
//            }
//        }
        
        public func resized(maxSize: CGFloat) -> Background {
            switch self {
            case .photo(let image):
                return .photo(image.resizedIfTooLarge(withSize: maxSize) ?? image)
            case .loading:
                return .loading
            }
        }
    }
    
    public enum BackgroundData: Codable, Hashable {
        
        case photo(_ data: Data)
        case photoLink(_ url: URL)
        
        public func background() async -> Background? {
            switch self {
            case .photo(let data):
                if let photo = UIImage(data: data) {
                    return .photo(photo)
                }
            case .photoLink(let url):
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    return .photo(image)
                }
            }
            return nil
        }
        
        public var icon: BackgroundData? {
            switch self {
            case .photo(let data):
                if let photo = UIImage(data: data), let compressed = photo.square()?.compressed(size: Card.maxIconSize) {
                    return .photo(compressed)
                }
            case .photoLink(_):
                return self
            }
            return nil
        }
    }
    
    // Update any photo links to raw photo data
    public func updateLink() async {
        if case .photoLink(let url) = backgroundData, let data = try? Data(contentsOf: url), 
            let image = UIImage(data: data), let photoData = image.compressed(size: Card.maxPhotoSize) {
            setBackground(.photo(photoData))
        }
    }
}
