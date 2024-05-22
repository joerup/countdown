//
//  CountdownRoot.swift
//  Countdown
//
//  Created by Joe Rupertus on 8/12/23.
//

import SwiftUI
import SwiftData
import CountdownData
import WidgetKit

struct CountdownRoot: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.scenePhase) var scenePhase
    
    @Query private var countdowns: [Countdown]
    
    @State private var selectedCountdown: Countdown?
    
    @StateObject private var clock: Clock = Clock()
    @StateObject private var premium: Premium = Premium()
    
    @State private var isLoaded: Bool = false
    
    var body: some View {
        Group {
            if isLoaded {
                CountdownView(countdowns: countdowns, selectedCountdown: $selectedCountdown)
            } else {
                loadingScreen
            }
        }
        .environmentObject(clock)
        .environmentObject(premium)
        .onAppear {
            // Start the clock
            clock.start(countdowns: countdowns)
            
            // Schedule all notifications
            clock.scheduleNotifications(for: countdowns)
            
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
            // Update premium
            await premium.update()
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
        .onOpenURL { url in
            // Set the selected countdown from a widget
            if let countdown = countdowns.first(where: { $0.id.uuidString == url.lastPathComponent }) {
                selectedCountdown = countdown
            }
        }
        .onChange(of: scenePhase) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: selectedCountdown) { oldCountdown, newCountdown in
            // Set the background timer
            oldCountdown?.stopCardTimer()
            newCountdown?.startCardTimer()
        }
        .onChange(of: countdowns) { oldCountdowns, newCountdowns in
            // Set notification and background for any new countdowns
            if let countdown = newCountdowns.first(where: { !oldCountdowns.contains($0) }) {
                clock.scheduleNotification(for: countdown)
                Task {
                    await countdown.fetchBackground()
                }
            }
        }
        .onChange(of: clock.notifications) { _, active in
            if active {
                clock.scheduleNotifications(for: countdowns)
            } else {
                clock.unscheduleNotifications()
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
