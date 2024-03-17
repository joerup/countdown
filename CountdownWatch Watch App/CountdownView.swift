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
    
    var body: some View {
        if countdowns.isEmpty {
            Text("No countdowns")
        } else {
            TabView {
                ForEach(countdowns) { countdown in
                    CountdownSquare(countdown: countdown)
                }
            }
            .tabViewStyle(.carousel)
        }
    }
}
