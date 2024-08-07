//
//  CountdownTimelineProvider.swift
//  CountdownWidget
//
//  Created by Joe Rupertus on 8/7/23.
//

import Foundation
import WidgetKit
import AppIntents
import SwiftData
import CountdownData

struct CountdownTimelineProvider: AppIntentTimelineProvider {
    
    typealias Entry = CountdownWidgetEntry
    
    // get countdown matching configuration id
    @MainActor
    func countdowns(for configuration: CountdownWidgetIntent) async -> [Countdown] {
        guard let id = configuration.countdown?.id else { return [] }
        let clock = Clock(modelContext: sharedModelContainer.mainContext)
        await clock.loadStaticCountdownData(predicate: #Predicate { $0.id == id })
        return clock.countdowns
    }
    
    // get first countdown for default option
    @MainActor
    func firstCountdown() async -> Countdown? {
        let clock = Clock(modelContext: sharedModelContainer.mainContext)
        await clock.loadStaticCountdownData()
        return clock.countdowns.filter({ !$0.isPastDay }).sorted().first
    }
    
    // placeholder while the widget loads
    func placeholder(in context: Context) -> Entry {
        return CountdownWidgetEntry(date: .now)
    }
    
    // snapshot displayed in the widget selection menu
    @MainActor
    func snapshot(for configuration: CountdownWidgetIntent, in context: Context) async -> Entry {
        guard let countdown = await firstCountdown() else { return .empty }
        return CountdownWidgetEntry(date: .now, countdown: countdown)
    }
    
    // the timeline of updates to the countdown
    // (scheduled to update every day at midnight)
    @MainActor
    func timeline(for configuration: CountdownWidgetIntent, in context: Context) async -> Timeline<Entry> {
        let countdowns = await countdowns(for: configuration)
        // return the correct countdown
        if let countdown = countdowns.first {
            let entry = CountdownWidgetEntry(date: .nextHour, countdown: countdown)
            return Timeline(entries: [entry], policy: .atEnd)
        } 
        // return a default first countdown
        else if let countdown = await firstCountdown() {
            let entry = CountdownWidgetEntry(date: .nextHour, countdown: countdown)
            return Timeline(entries: [entry], policy: .atEnd)
        }
        return Timeline(entries: [.empty], policy: .never)
    }
}

struct CountdownWidgetEntry: TimelineEntry {
    var date: Date
    var countdown: Countdown?
    
    static var empty: Self {
        Self(date: .now)
    }
}
