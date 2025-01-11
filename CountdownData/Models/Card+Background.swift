//
//  Card+Background.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/5/23.
//

import Foundation
import SwiftUI

extension Card {
    
    public struct Background {
        var id: UUID
        public private(set) var data: Data
        public private(set) var previewData: Data?
        
        public private(set) var full: UIImage?
        public private(set) var square: UIImage?
        
        init?(id: UUID, imageData: Data?, previewImageData: Data?, transforms: BackgroundTransforms?) async {
            guard let imageData, let previewImageData, let image = UIImage(data: imageData), let previewImage = UIImage(data: previewImageData) else { return nil }
            let transforms = transforms ?? .init()
            
            self.id = id
            self.data = imageData
            self.previewData = previewImageData
            
            self.full = image
            self.square = previewImage.cropped(offset: transforms.square.offset, scale: transforms.square.scale)
        }
    }
    
    public struct BackgroundTransforms: Codable, Equatable, Hashable {
        public var full: ImageTransform
        public var square: ImageTransform
        
        public init(full: ImageTransform = .init(), square: ImageTransform = .init()) {
            self.full = full
            self.square = square
        }
    }
    
    
    /* DEPRECATED */
    /* DEPRECATED */
    /* DEPRECATED */
    // Now stored as `background` Data property in Card (no enum)
    public enum BackgroundData: Codable, Hashable {
        case photo(_ data: Data)
        case photoLink(_ url: URL)
    }
    /* ----------- */
    /* ----------- */
    /* ----------- */
    
    // Update any old background that exists
    public func updateOldBackgrounds() async {
        switch backgroundData {
        case .photo(let data):
            setBackground(data)
        case .photoLink(let url):
            if let data = try? Data(contentsOf: url) {
                setBackground(data)
            }
        default:
            break
        }
        removeOldBackgrounds()
    }
}


