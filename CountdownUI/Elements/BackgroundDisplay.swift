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
    private var color: Color
    private var fade: Double
    private var blur: Double
    private var brightness: Double
    private var saturation: Double
    private var contrast: Double
    private var fullScreen: Bool
    
    public init(background: Card.Background?, color: Color = .white, fade: Double = 0, blur: Double = 0, brightness: Double = 0, saturation: Double = 1.0, contrast: Double = 1.0, fullScreen: Bool = false) {
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
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .saturation(saturation)
                    .brightness(brightness)
                    .contrast(contrast)
                    .blur(radius: blur)
            case .transformedPhoto(let photo, let offset, let scale):
                if fullScreen {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .saturation(saturation)
                        .brightness(brightness)
                        .contrast(contrast)
                        .blur(radius: blur)
                } else if let croppedPhoto = photo.cropped(offset: offset, scale: scale) {
                    Image(uiImage: croppedPhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .saturation(saturation)
                        .brightness(brightness)
                        .contrast(contrast)
                        .blur(radius: blur)
                }
            case .loading, nil:
                Color.defaultColor
            }
            
            if background?.allowOverlays ?? false {
                Rectangle()
                    .fill(color)
                    .opacity(fade)
            }
        }
    }
}

