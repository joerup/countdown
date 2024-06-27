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
    
    @State private var newCountdown: Countdown?
    @State private var requestNewCountdown: Bool = false
    
    var body: some View {
        Group {
            if clock.isLoaded {
                CountdownView(countdowns: countdowns.filter(\.isSaved), selectedCountdown: $selectedCountdown)
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
            if let countdown = Countdown.fromLinkURL(url, countdowns: countdowns) {
                if countdown.isSaved {
                    selectedCountdown = countdown
                } else {
                    newCountdown = countdown
                    requestNewCountdown = true
                }
            }
        }
        .alert(isPresented: $requestNewCountdown) {
            Alert(title: Text("Add \(newCountdown?.displayName ?? "")"), message: Text("Would you like to save this countdown?"),
                primaryButton: .default(Text("Save")) {
                    withAnimation {
                        newCountdown?.isSaved = true
                        selectedCountdown = newCountdown
                        newCountdown = nil
                    }
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    newCountdown = nil
                }
            )
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
                    await clock.refresh(countdowns: [countdown])
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
