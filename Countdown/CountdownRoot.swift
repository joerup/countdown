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
    
    @State private var clock: Clock
    @State private var premium: Premium = Premium()
    
    init(modelContext: ModelContext) {
        let clock = Clock(modelContext: modelContext)
        _clock = State(initialValue: clock)
    }
    
    var body: some View {
        Group {
            if clock.isLoaded {
                CountdownView()
            } else {
                loadingScreen
            }
        }
        .environment(clock)
        .environment(premium)
        .task { 
            await premium.update()
        }
        .onOpenURL { url in
            if let id = clock.link(from: url) {
                clock.select(id)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active: clock.didBecomeActive()
            case .background: clock.didEnterBackground()
            case .inactive: clock.didBecomeInactive()
            default: break
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
