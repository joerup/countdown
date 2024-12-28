//
//  CountdownWidget.swift
//  CountdownWidget
//
//  Created by Joe Rupertus on 8/7/23.
//

import WidgetKit
import SwiftUI
import AppIntents
import CountdownData
import CountdownUI
import SwiftData

struct CountdownWidget: Widget {
     
    let kind: String = "CountdownWidget"
    
    private let maxSize: CGFloat = 500
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CountdownWidgetIntent.self, provider: CountdownTimelineProvider()) { entry in
            if let countdown = entry.countdown {
                CountdownSquareText(countdown: countdown)
                    .padding(.bottom, -10)
                    .containerBackground(for: .widget) {
                        BackgroundDisplay(background: countdown.currentBackgroundIcon?.resized(maxSize: maxSize), color: countdown.currentBackgroundColor, fade: countdown.currentBackgroundFade, blur: countdown.currentBackgroundBlur)
                            .scaleEffect(1.01)
                    }
                    .widgetURL(countdown.getURL())
            } else {
                Text("No countdowns")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .containerBackground(.background, for: .widget)
            }
        }
        .configurationDisplayName("Countdown")
        .description("Display a live countdown.")
        .supportedFamilies([.systemSmall])
    }
}
