//
//  Countdown+Background.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import Foundation
import SwiftUI

extension Countdown {
    
    enum Background {
        
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
    
    enum BackgroundData: Codable, Hashable {
        
        case photo(_ data: Data)
        case gradient(_ colors: [Color])
        
        var background: Background? {
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
    
    func loadBackgrounds() async {
        backgrounds = backgroundData.compactMap { $0.background }
        backgroundIndex = backgrounds.isEmpty ? nil : 0
    }
    
    func addBackground(_ background: Background) {
        if let data = background.data {
            backgroundData.append(data)
            backgrounds.append(background)
            backgroundIndex = backgrounds.count-1
        }
    }
    func removeBackground(at index: Int) {
        backgroundData.remove(at: index)
        backgrounds.remove(at: index)
        backgroundIndex = backgrounds.isEmpty ? nil : 0
    }
    
    func startBackgroundTimer() {
        backgroundTimer?.invalidate()
        guard backgroundCycleEnabled, backgrounds.count > 1 else { return }
        backgroundTimer = Timer.scheduledTimer(withTimeInterval: backgroundCycleDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2.0)) {
                self.cycleBackgrounds()
            }
        }
    }
    func stopBackgroundTimer() {
        backgroundTimer?.invalidate()
    }
    func cycleBackgrounds() {
        guard let backgroundIndex else { return }
        if backgroundIndex+1 < backgrounds.count {
            self.backgroundIndex = backgroundIndex + 1
        } else {
            self.backgroundIndex = 0
        }
    }
}
