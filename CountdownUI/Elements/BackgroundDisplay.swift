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
    private var fullScreen: Bool
    
    public init(background: Card.Background?, color: Color, fade: Double, blur: Double = 0, fullScreen: Bool = false) {
        self.background = background
        self.color = color
        self.fade = fade
        self.blur = blur
        self.fullScreen = fullScreen
    }
    
    public var body: some View {
        ZStack {
            switch background {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blur)
            case .transformedPhoto(let photo, let offset, let scale):
                if fullScreen {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: blur)
                } else {
                    CroppedImage(image: photo, cropRect: imageSquare(imageSize: photo.size, offset: offset, scale: scale))
                        .blur(radius: blur)
                }
            case .loading, nil:
                EmptyView()
            }
            
            Rectangle()
                .fill(color)
                .opacity(fade)
        }
    }
    
    private func imageSquare(imageSize: CGSize, offset: CGSize, scale: CGFloat) -> CGRect {
        let size = imageSize.minimum / scale
        let x = imageSize.width/2 - offset.width - size/2
        let y = imageSize.height/2 - offset.height - size/2
        return CGRect(x: x, y: y, width: size, height: size)
    }
}

