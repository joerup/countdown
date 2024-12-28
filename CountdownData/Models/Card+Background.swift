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
        case transformedPhoto(_ photo: UIImage, offset: CGSize, scale: CGFloat)
        case loading
        
        public func resized(maxSize: CGFloat) -> Background {
            switch self {
            case .photo(let image):
                return .photo(image.resizedIfTooLarge(withSize: maxSize) ?? image)
            case .transformedPhoto(let image, let offset, let scale):
                return .transformedPhoto(image.resizedIfTooLarge(withSize: maxSize) ?? image, offset: offset, scale: scale)
            case .loading:
                return .loading
            }
        }
        
        public var image: UIImage? {
            switch self {
            case .photo(let photo):
                return photo
            case .transformedPhoto(let photo, _, _):
                return photo
            default:
                return nil
            }
        }
        
        public var allowOverlays: Bool {
            switch self {
            case .photo(_), .transformedPhoto(_, _, _):
                return true
            case .loading:
                return false
            }
        }
    }
    
    public enum BackgroundData: Codable, Hashable {
        
        case photo(_ data: Data)
        case transformedPhoto(_ data: Data, offsetX: CGFloat, offsetY: CGFloat, scale: CGFloat)
        case photoLink(_ url: URL)
        
        public func background() async -> Background? {
            switch self {
            case .photo(let data):
                if let photo = UIImage(data: data) {
                    return .photo(photo)
                }
            case .transformedPhoto(let data, let offsetX, let offsetY, let scale):
                if let photo = UIImage(data: data) {
                    return .transformedPhoto(photo, offset: CGSize(width: offsetX, height: offsetY), scale: scale)
                }
            case .photoLink(let url):
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    return .photo(image)
                }
            }
            return nil
        }
        
        public var icon: Self? {
            switch self {
            case .photo(let data):
                if let photo = UIImage(data: data), let compressed = photo.square()?.compressed(size: Card.maxIconSize) {
                    return .photo(compressed)
                }
            case .transformedPhoto(let data, let offsetX, let offsetY, let scale):
                if let photo = UIImage(data: data), let compressed = photo.square()?.compressed(size: Card.maxIconSize) {
                    return .transformedPhoto(compressed, offsetX: offsetX, offsetY: offsetY, scale: scale)
                }
            case .photoLink(_):
                return self
            }
            return nil
        }
        
        public var transforms: (offset: CGSize, scale: CGFloat) {
            switch self {
            case .transformedPhoto(_, let offsetX, let offsetY, let scale):
                return (offset: CGSize(width: offsetX, height: offsetY), scale: scale)
            default:
                return (offset: .zero, scale: 1.0)
            }
        }
        
        public func repositioned(offset: CGSize, scale: CGFloat) -> Self {
            switch self {
            case .photo(let data):
                return .transformedPhoto(data, offsetX: offset.width, offsetY: offset.height, scale: scale)
            case .transformedPhoto(let data, _, _, _):
                return .transformedPhoto(data, offsetX: offset.width, offsetY: offset.height, scale: scale)
            default:
                return self
            }
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
