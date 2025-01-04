//
//  BackgroundDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
        
    private var image: UIImage?
    private var color: Color?
    private var fade: Double
    private var blur: Double
    private var brightness: Double
    private var saturation: Double
    private var contrast: Double
    
    public init(background: UIImage?, color: Color? = nil, fade: Double = 0, blur: Double = 0, brightness: Double = 0, saturation: Double = 1.0, contrast: Double = 1.0) {
        self.image = background
        self.color = color
        self.fade = fade
        self.blur = blur
        self.brightness = brightness
        self.saturation = saturation
        self.contrast = contrast
    }
    
    public var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
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
                if let color {
                    Rectangle()
                        .fill(color)
                        .opacity(fade)
                }
            } else {
                Color.defaultColor
            }
        }
    }
}

