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
    
    @State private var isLoaded: Bool = false
    
    var body: some View {
        Group {
            if isLoaded {
                CountdownView(countdowns: countdowns)
            } else {
                loadingScreen
            }
        }
        .environmentObject(clock)
        .onAppear {
            // Start the clock
            clock.start(countdowns: countdowns)
            
            // Add cards to empty countdowns
            for countdown in countdowns {
                if let cards = countdown.cards {
                    if cards.isEmpty {
                        countdown.addCard(Card())
                    }
                } else {
                    countdown.cards = [Card()]
                }
            }
        }
        .task {
            // Fetch countdown backgrounds
            for countdown in countdowns {
                await countdown.fetchBackground()
            }
            withAnimation {
                isLoaded = true
            }
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
                .font(.system(.body, design: .rounded, weight: .semibold))
                .multilineTextAlignment(.center)
        }
    }
}
