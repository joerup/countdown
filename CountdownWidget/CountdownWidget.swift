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

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CountdownWidgetIntent.self, provider: CountdownTimelineProvider()) { entry in
            if let countdown = entry.countdown {
                Text("")
                    .containerBackground(for: .widget) {
                        CountdownSquare(countdown: countdown)
                    }
                    .widgetURL(URL(string: "countdown:///\(countdown.id)"))
            } else {
                Text("No countdowns")
            }
        }
        .configurationDisplayName("Countdown")
        .description("Show a countdown on your home screen.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}
