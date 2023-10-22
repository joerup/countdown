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
    }
    
    public enum BackgroundData: Codable, Hashable {
        
        case photo(_ data: Data)
        case photoLink(_ url: URL)
        
        public func background() async -> Background? {
            print("FETCHING BACKGROUND INFO")
            switch self {
            case .photo(let data):
                print("FROM DATA")
                if let photo = UIImage(data: data) {
                    return .photo(photo)
                }
            case .photoLink(let url):
                print("FROM LINK")
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    return .photo(image)
                }
            }
            return nil
        }
    }
}

