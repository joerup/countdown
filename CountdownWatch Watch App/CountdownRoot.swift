//
//  CountdownRoot.swift
//  CountdownWatch Watch App
//
//  Created by Joe Rupertus on 11/21/23.
//

import SwiftUI
import SwiftData
import CountdownData
import WidgetKit

struct CountdownRoot: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.scenePhase) var scenePhase
    
    @Query private var countdowns: [Countdown]
    
    @StateObject private var clock: Clock = Clock()
    
    var body: some View {
        Group {
            if clock.isLoaded {
                CountdownView(countdowns: countdowns.filter(\.isSaved))
            } else {
                loadingScreen
            }
        }
        .environmentObject(clock)
        .task {
            await clock.start(countdowns: countdowns)
        }
        .onChange(of: scenePhase) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: countdowns) { oldCountdowns, newCountdowns in
            // Set notification and background for any new countdowns
            if let countdown = newCountdowns.first(where: { !oldCountdowns.contains($0) }) {
                Task {
                    await countdown.fetchBackground()
                }
            }
        }
    }
    
    private var loadingScreen: some View {
        VStack {
            ProgressView()
                .padding()
            Text("Loading Countdowns")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
    }
}
