//
//  BackgroundDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
    
    var countdown: Countdown
    var blurRadius: Double = 0
    
    public init(countdown: Countdown) {
        self.countdown = countdown
        self.blurRadius = 0
    }
    public init(countdown: Countdown, blurRadius: Double = 0) {
        self.countdown = countdown
        self.blurRadius = blurRadius
    }
    
    public var body: some View {
        Group {
            switch countdown.cards.first?.background ?? .none {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blurRadius)
            case .gradient(let colors):
                LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            case .none:
                Color.red
            }
        }
        .id(countdown.daysRemaining) // keep this
    }
}
