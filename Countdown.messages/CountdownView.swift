//
//  CountdownView.swift
//  Countdown.messages
//
//  Created by Joe Rupertus on 5/28/24.
//

import SwiftUI
import SwiftData
import CountdownData

struct CountdownView: View {
    
    var countdowns: [Countdown]
    
    private var sortedCountdowns: [Countdown] {
        return countdowns.filter { !$0.isPastDay } .sorted()
    }
    
    @State private var isLoaded: Bool = false
    
    var body: some View {
        Group {
            if isLoaded {
                CountdownGrid(countdowns: sortedCountdowns)
            } else {
                loadingScreen
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
