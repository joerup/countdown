//
//  CountdownRoot.swift
//  Countdown
//
//  Created by Joe Rupertus on 8/12/23.
//

import SwiftUI
import SwiftData
import CountdownData

struct CountdownRoot: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @State private var selectedCountdown: Countdown?
    
    @State private var clock: Clock
    @StateObject private var premium: Premium = Premium()
    
    init(modelContext: ModelContext) {
        let clock = Clock(modelContext: modelContext)
        _clock = State(initialValue: clock)
    }
    
    // MARK: NEXT STEPS ---- move selectedCountdown to viewmodel, add state to fetchData to update that value when a url has been entered (save it in the viewmodel as text) from this view
    
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
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active: clock.didBecomeActive()
            default: clock.didEnterBackground()
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
