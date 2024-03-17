//
//  CountdownWatchApp.swift
//  CountdownWatch Watch App
//
//  Created by Joe Rupertus on 11/21/23.
//

import SwiftUI
import SwiftData
import CountdownData

@main
struct CountdownWatchApp: App {

    var body: some Scene {
        WindowGroup {
            CountdownRoot()
        }
        .modelContainer(for: Countdown.self)
    }
}
