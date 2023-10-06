//
//  BackgroundDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI

struct BackgroundDisplay: View {
    
    var countdown: Countdown?
    var background: Countdown.Background?
    var blurRadius: Double = 0
    
    init(countdown: Countdown) {
        self.countdown = countdown
    }
    init(widget: Countdown) {
        if let index = widget.backgroundIndex {
            self.background = widget.backgroundData[index].background
        }
    }
    init(background: Countdown.Background?, blurRadius: Double = 0) {
        self.background = background
        self.blurRadius = blurRadius
    }
    
    var body: some View {
        Group {
            if let background = countdown?.background ?? background {
                switch background {
                case .photo(let photo):
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: blurRadius)
                case .gradient(let colors):
                    LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
                }
            }
            else {
                Color.pink
            }
        }
        .id(countdown?.backgroundIndex)
    }
}
