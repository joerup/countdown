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
    
    @Environment(\.scenePhase) var scenePhase
    
    @State private var selectedCountdown: Countdown?
    
    @State private var clock: Clock
    @StateObject private var premium: Premium = Premium()
    
    @State private var newCountdown: CountdownInstance?
    @State private var requestNewCountdown: Bool = false
    
    init(modelContext: ModelContext) {
        let clock = Clock(modelContext: modelContext)
        _clock = State(initialValue: clock)
    }
    
    var body: some View {
        Group {
            if clock.isLoaded {
                CountdownView(selectedCountdown: $selectedCountdown)
            } else {
                loadingScreen
            }
        }
        .environment(clock)
        .environmentObject(premium)
        .task { 
            await premium.update()
        }
        .onOpenURL { url in
            if let countdown = clock.getCountdown(from: url) {
                selectedCountdown = countdown
            }
        }
        .onChange(of: scenePhase) {
            WidgetCenter.shared.reloadAllTimelines()
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
