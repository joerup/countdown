//
//  BackgroundDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
        
    private var background: Card.Background?
    private var color: Color?
    private var fade: Double
    private var blur: Double
    private var brightness: Double
    private var saturation: Double
    private var contrast: Double
    private var fullScreen: Bool
    
    public init(background: Card.Background?, color: Color? = nil, fade: Double = 0, blur: Double = 0, brightness: Double = 0, saturation: Double = 1.0, contrast: Double = 1.0, fullScreen: Bool = false) {
        self.background = background
        self.color = color
        self.fade = fade
        self.blur = blur
        self.brightness = brightness
        self.saturation = saturation
        self.contrast = contrast
        self.fullScreen = fullScreen
    }
    
    public var body: some View {
        ZStack {
            switch background {
            case .photo(let photo):
                modifiedImage(photo)
            case .loading, nil:
                Color.defaultColor
            }
            
            if let color, background?.allowOverlays ?? false {
                Rectangle()
                    .fill(color)
                    .opacity(fade)
            }
        }
    }
    
    private func modifiedImage(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .scaleEffect(1.01)
            .saturation(saturation)
            .contrast(contrast)
            .blur(radius: blur)
            .overlay {
                Color.black.opacity(max(-brightness, 0))
                Color.white.opacity(max(brightness, 0))
            }
    }
}

