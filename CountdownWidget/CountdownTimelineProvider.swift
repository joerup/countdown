//
//  CountdownTimelineProvider.swift
//  CountdownWidgetExtension
//
//  Created by Joe Rupertus on 8/7/23.
//

import Foundation
import WidgetKit
import AppIntents
import SwiftData
import CountdownData

struct CountdownTimelineProvider: AppIntentTimelineProvider {
    let modelContainer = try? ModelContainer(for: Countdown.self)
    
    typealias Entry = CountdownWidgetEntry
    
    @MainActor
    func countdowns(for configuration: CountdownWidgetIntent) -> [Countdown] {
        if let id = configuration.countdown?.id {
            return (try? modelContainer?.mainContext.fetch(FetchDescriptor<Countdown>(predicate: #Predicate { $0.id == id })).sorted(by: { $0.date < $1.date })) ?? []
        } else {
            return (try? modelContainer?.mainContext.fetch(FetchDescriptor<Countdown>()).sorted(by: { $0.date < $1.date })) ?? []
        }
    }
    
    func placeholder(in context: Context) -> Entry {
        let countdown = Countdown(name: "Test", date: .now)
        return CountdownWidgetEntry(date: .now, countdown: countdown)
    }
    
    @MainActor
    func snapshot(for configuration: CountdownWidgetIntent, in context: Context) async -> Entry {
        let countdowns = countdowns(for: configuration)
        guard let countdown = countdowns.first else { return .empty }
        return CountdownWidgetEntry(date: .now, countdown: countdown)
    }
    
    @MainActor
    func timeline(for configuration: CountdownWidgetIntent, in context: Context) async -> Timeline<Entry> {
        let countdowns = countdowns(for: configuration)
        guard let countdown = countdowns.first else { return Timeline(entries: [.empty], policy: .never) }
        let entry = CountdownWidgetEntry(date: .now, countdown: countdown)
        return Timeline(entries: [entry], policy: .atEnd)
    }
}

struct CountdownWidgetEntry: TimelineEntry {
    var date: Date
    var countdown: Countdown?
    
    static var empty: Self {
        Self(date: .now)
    }
}
