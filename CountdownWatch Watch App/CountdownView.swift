//
//  CountdownView.swift
//  CountdownWatch Watch App
//
//  Created by Joe Rupertus on 11/21/23.
//

import SwiftUI
import CountdownUI
import CountdownData

struct CountdownView: View {
    
    var countdowns: [Countdown]
    var sortedCountdowns: [Countdown] {
        countdowns.filter { !$0.isPastDay } .sorted()
    }
    
    var body: some View {
        if sortedCountdowns.isEmpty {
            Text("No countdowns")
        } else {
            TabView {
                ForEach(sortedCountdowns) { countdown in
                    CountdownSquare(countdown: countdown)
                }
            }
            .tabViewStyle(.carousel)
        }
    }
}
