//
//  CountdownApp.swift
//  Countdown
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import SwiftData
import CountdownData

@main
struct CountdownApp: App {
    
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            CountdownRoot(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Countdown.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
}
