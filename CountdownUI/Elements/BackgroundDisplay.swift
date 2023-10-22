//
//  BackgroundDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
    
    @EnvironmentObject private var clock: Clock
    
    var countdown: Countdown
    var blurRadius: Double = 0
    
    public var body: some View {
        Group {
            switch countdown.currentBackground {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blurRadius)
            case .loading, nil:
                Rectangle().fill(Constants.color)
            }
        }
        .id(clock.tick)
        .onChange(of: countdown.card?.backgroundData) { _, _ in
            Task {
                await countdown.fetchBackground()
            }
        }
    }
}
