//
//  CountdownTimeView.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/12/23.
//

import SwiftUI
import SwiftData
import CountdownData

struct CountdownTimeView: View {
    
    @Query private var countdowns: [Countdown]
    @State private var selectedCountdown: Countdown?
    
    @State private var countdownTimer: Timer?
    
    var body: some View {
        CountdownList(countdowns: countdowns, selectedCountdown: $selectedCountdown)
            .onAppear {
                // Start the countdown timer
                countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    for countdown in countdowns {
                        countdown.setTimeRemaining()
                    }
                }
            }
            .task {
                // Load countdown backgrounds
                for countdown in countdowns {
                    await countdown.loadCards()
                }
            }
            .onOpenURL { url in
                // Set the selected countdown from a widget
                if let countdown = countdowns.first(where: { $0.id == url.lastPathComponent }) {
                    selectedCountdown = countdown
                }
            }
            .onChange(of: selectedCountdown) { oldCountdown, newCountdown in
                // Set the background timer
                oldCountdown?.stopCardTimer()
                newCountdown?.startCardTimer()
            }
    }
}
