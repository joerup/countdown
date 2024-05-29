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
    
    var body: some View {
        Group {
            if clock.isLoaded {
                CountdownView(countdowns: countdowns, selectedCountdown: $selectedCountdown)
            } else {
                loadingScreen
            }
        }
        .environmentObject(clock)
        .environmentObject(premium)
        .task {
            await clock.start(countdowns: countdowns)
        }
        .task {
            await premium.update()
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
