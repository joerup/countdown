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
                VStack(alignment: .leading) {
                    TitleDisplay(countdown: countdown, size: 25, arrangement: .vertical(alignment: .leading))
                    Spacer(minLength: 0)
                    HStack {
                        Spacer()
                        CounterDisplay(countdown: countdown, size: 55)
                    }
                    .padding(.bottom, -7)
                }
                .containerBackground(for: .widget) {
                    BackgroundDisplay(card: countdown.card)
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
