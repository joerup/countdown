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
        var countdowns: [Countdown] = []
        if let id = configuration.countdown?.id {
            countdowns = (try? sharedModelContainer.mainContext.fetch(FetchDescriptor<Countdown>(predicate: #Predicate { $0.id == id })).sorted()) ?? []
        }
        for countdown in countdowns {
            await countdown.fetchBackground()
        }
        return countdowns
    }
    
    // get first countdown for default option
    @MainActor
    func firstCountdown() async -> Countdown? {
        guard let countdown = (try? sharedModelContainer.mainContext.fetch(FetchDescriptor<Countdown>()).filter({ !$0.isPastDay }).sorted())?.first else { return nil }
        await countdown.fetchBackground()
        return countdown
    }
    
    // get the countdown card
    @MainActor
    func card(for countdown: Countdown) async -> Card? {
        guard let cards = (try? sharedModelContainer.mainContext.fetch(FetchDescriptor<Card>())) else { return nil }
        return cards.first(where: { $0.countdown == countdown })
    }
    
    // placeholder while the widget loads
    func placeholder(in context: Context) -> Entry {
        let countdown = Countdown(name: "Test", date: .now)
        return CountdownWidgetEntry(date: .now, countdown: countdown)
    }
    
    // snapshot displayed in the widget selection menu
    @MainActor
    func snapshot(for configuration: CountdownWidgetIntent, in context: Context) async -> Entry {
        guard let countdown = await firstCountdown() else { return .empty }
        let card = await card(for: countdown)
        return CountdownWidgetEntry(date: .now, countdown: countdown, card: card)
    }
    
    // the timeline of updates to the countdown
    // (scheduled to update every day at midnight)
    @MainActor
    func timeline(for configuration: CountdownWidgetIntent, in context: Context) async -> Timeline<Entry> {
        let countdowns = await countdowns(for: configuration)
        // return the correct countdown
        if let countdown = countdowns.first {
            let card = await card(for: countdown)
            let entry = CountdownWidgetEntry(date: .tomorrow.midnight, countdown: countdown, card: card)
            return Timeline(entries: [entry], policy: .atEnd)
        } 
        // return a default first countdown
        else if let countdown = await firstCountdown() {
            let card = await card(for: countdown)
            let entry = CountdownWidgetEntry(date: .tomorrow.midnight, countdown: countdown, card: card)
            return Timeline(entries: [entry], policy: .never)
        }
        return Timeline(entries: [.empty], policy: .never)
    }
}

struct CountdownWidgetEntry: TimelineEntry {
    var date: Date
    var countdown: Countdown?
    var card: Card?
    
    static var empty: Self {
        Self(date: .now)
    }
}
