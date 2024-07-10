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
    @State private var newCountdown: CountdownInstance?
    @State private var requestNewCountdown: Bool = false
    
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
        .task {
            for countdown in countdowns {
                await countdown.loadCards()
            }
            isLoaded = true
        }
        .task {
            await premium.update()
        }
        .onOpenURL { url in
            if let countdown = Countdown.fromLinkURL(url, countdowns: countdowns) {
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
            // Referesh new countdown
            for countdown in newCountdowns.filter({ !oldCountdowns.contains($0) }) {
                clock.scheduleNotification(for: countdown)
                Task {
                    await countdown.loadCards()
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
