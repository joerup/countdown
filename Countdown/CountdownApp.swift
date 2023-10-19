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
struct CountdownTimeApp: App {
    
    var body: some Scene {
        WindowGroup {
            CountdownRoot()
        }
        .modelContainer(for: Countdown.self)
    }
}
