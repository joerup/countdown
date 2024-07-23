//
//  CountdownWidgetBundle.swift
//  CountdownWidget
//
//  Created by Joe Rupertus on 8/7/23.
//

import WidgetKit
import SwiftUI
import CountdownData
import SwiftData

@main
struct CountdownWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountdownWidget()
    }
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Countdown.self, Card.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
