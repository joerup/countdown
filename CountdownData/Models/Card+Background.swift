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
    
    public enum Background {
        case photo(_ photo: UIImage)
        case loading
        
        public func resized(maxSize: CGFloat) -> Background {
            switch self {
            case .photo(let image):
                return .photo(image.resizedIfTooLarge(withSize: maxSize) ?? image)
            case .loading:
                return .loading
            }
        }
        
        public var image: UIImage? {
            switch self {
            case .photo(let photo):
                return photo
            default:
                return nil
            }
        }
        
        public var allowOverlays: Bool {
            switch self {
            case .photo(_):
                return true
            case .loading:
                return false
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
        
        public func icon(transform: ImageTransform? = nil) -> Self? {
            switch self {
            case .photo(let data):
                if let photo = UIImage(data: data), let cropped = photo.cropped(offset: transform?.offset ?? .zero, scale: transform?.scale ?? 1), let croppedData = cropped.jpegData(compressionQuality: 0.75) {
                    return .photo(croppedData)
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
    
    public struct ImageTransform: Codable, Equatable, Hashable {
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        public var offset: CGSize {
            return .init(width: offsetX, height: offsetY)
        }
        
        public var scale: CGFloat = 1.0
        
        public init() { }
        
        public init(offset: CGSize, scale: CGFloat) {
            self.offsetX = offset.width
            self.offsetY = offset.height
            self.scale = scale
        }
    }
}
