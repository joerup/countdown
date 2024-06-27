//
//  BackgroundDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
    
    @EnvironmentObject private var clock: Clock
    
    var countdown: Countdown
    var icon: Bool
    var blurRadius: Double = 0
    
    private var background: Card.Background? {
        return icon ? countdown.currentBackgroundIcon : countdown.currentBackground
    }
    
    public init(countdown: Countdown, icon: Bool = false, blurRadius: Double = 0) {
        self.countdown = countdown
        self.icon = icon
        self.blurRadius = blurRadius
    }
    
    public var body: some View {
        Group {
            switch background {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blurRadius)
            case .loading, nil:
                Rectangle().fill(Color.init(red: 163/255, green: 55/255, blue: 68/255))
            }
        }
        .onChange(of: countdown.card?.backgroundData) { _, _ in
            Task {
                await clock.refresh(countdowns: [countdown])
            }
        }
    }
}
