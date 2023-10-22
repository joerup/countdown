//
//  CountdownRoot.swift
//  Countdown
//
//  Created by Joe Rupertus on 8/12/23.
//

import SwiftUI
import SwiftData
import CountdownData
import CoreData

struct CountdownRoot: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var countdowns: [Countdown]
    
    @State private var selectedCountdown: Countdown?
    
    @StateObject private var clock: Clock = Clock()
    
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
        .onAppear {
            // Start the clock
            clock.start(countdowns: countdowns)
        }
        .onAppear {
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
            if let countdown = countdowns.first(where: { $0.name == url.lastPathComponent }) {
                selectedCountdown = countdown
            }
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
