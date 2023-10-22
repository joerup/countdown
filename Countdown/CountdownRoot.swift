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
    
    @State private var countdownTimer: Timer?
    
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
            // Start the countdown timer
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if clock.active {
                    for countdown in countdowns {
                        clock.setTimeRemaining(for: countdown)
                    }
                    clock.tick.toggle()
                }
            }
        }
        .onAppear {
            clock.scheduleNotifications(for: countdowns)
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
