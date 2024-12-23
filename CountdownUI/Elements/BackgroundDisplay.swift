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
    private var blurRadius: Double = 0
    
    public init(background: Card.Background?, color: Color, fade: Double, blurRadius: Double = 0) {
        self.background = background
        self.color = color
        self.fade = fade
        self.blurRadius = blurRadius
    }
    
    public var body: some View {
        ZStack {
            switch background {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blurRadius)
                    .overlay {
                        Rectangle()
                            .fill(color)
                            .opacity(fade)
                    }
            case .loading:
                Color.defaultColor
            case nil:
                Rectangle()
                    .fill(color)
                    .opacity(fade)
            }
        }
    }
}
