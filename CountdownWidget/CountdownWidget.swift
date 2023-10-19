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

struct CountdownWidget: Widget {
     
    let kind: String = "CountdownWidget"
    
    @State private var clock: Clock = Clock()

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CountdownWidgetIntent.self, provider: CountdownTimelineProvider()) { entry in
            if let countdown = entry.countdown {
                Text("")
                    .containerBackground(for: .widget) {
                        CountdownSquare(countdown: countdown)
                            .environmentObject(clock)
                            .onAppear {
                                clock.setTimeRemaining(for: countdown)
                                clock.tick.toggle()
                            }
                    }
                    .widgetURL(URL(string: "countdown:///\(countdown.id)"))
            } else {
                Text("No countdowns")
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .containerBackground(for: .widget) {
                        Color.white
                    }
            }
        }
        .configurationDisplayName("Countdown")
        .description("Show a countdown on your home screen.")
        .supportedFamilies([.systemSmall])
    }
}
