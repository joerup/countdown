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
    
    @State private var clock: Clock = Clock()
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CountdownWidgetIntent.self, provider: CountdownTimelineProvider()) { entry in
            if let countdown = entry.countdown, let card = entry.card {
                Text("")
                    .containerBackground(for: .widget) {
                        CountdownSquare(countdown: countdown, card: card)
                            .environmentObject(clock)
                    }
                    .widgetURL(URL(string: "countdown:///\(countdown.name)"))
            } else {
                Text("No countdowns")
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .containerBackground(.background, for: .widget)
            }
        }
        .configurationDisplayName("Countdown")
        .description("Select a countdown to display.")
        .supportedFamilies([.systemSmall])
    }
}
