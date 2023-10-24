//
//  CountdownWidgetIntent.swift
//  CountdownWidgetExtension
//
//  Created by Joe Rupertus on 8/7/23.
//

import Foundation
import WidgetKit
import AppIntents
import SwiftData
import CountdownData

struct CountdownWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Countdown"
    static var description = IntentDescription("Select the countdown to display.")

    @Parameter(title: "Countdown")
    var countdown: CountdownEntity?

    init(countdown: CountdownEntity? = nil) {
        self.countdown = countdown
    }

    init() {
    }
}

struct CountdownEntity: AppEntity, Identifiable, Hashable {
    var id: Countdown.ID
    var name: String
    
    init(from countdown: Countdown) {
        self.id = countdown.id
        self.name = countdown.displayName
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Countdown"
    static var defaultQuery = CountdownEntityQuery()
}

struct CountdownEntityQuery: EntityQuery {
    
    // get countdown corresponding to id
    @MainActor
    func entities(for identifiers: [CountdownEntity.ID]) async throws -> [CountdownEntity] {
        guard
            let modelContainer = try? ModelContainer(for: Countdown.self),
            let countdowns = try? modelContainer.mainContext.fetch(FetchDescriptor<Countdown>(predicate: #Predicate { identifiers.contains($0.id) }))
        else {
            print("Failed to get countdowns")
            return []
        }
        return countdowns.sorted().map { CountdownEntity(from: $0) }
    }
    
    // get list of countdowns to select from
    @MainActor
    func suggestedEntities() async throws -> [CountdownEntity] {
        guard
            let modelContainer = try? ModelContainer(for: Countdown.self),
            let countdowns = try? modelContainer.mainContext.fetch(FetchDescriptor<Countdown>())
        else {
            print("Failed to get countdowns")
            return []
        }
        return countdowns.filter { !$0.isPastDay } .sorted().map { CountdownEntity(from: $0) }
    }
}
