//
//  CountdownMessageContainer.swift
//  Countdown.messages
//
//  Created by Joe Rupertus on 5/28/24.
//

import Foundation
import SwiftData
import CountdownData

public var sharedModelContainer: ModelContainer = {
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
