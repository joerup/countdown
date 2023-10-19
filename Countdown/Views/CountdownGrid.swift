//
//  CountdownGrid.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 10/18/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownGrid: View {
    
    var countdowns: [Countdown]
    
    @Binding var selectedCountdown: Countdown?
    
    var body: some View {
        if countdowns.isEmpty {
            Text("No countdowns are currently active!")
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(.gray)
                .padding(50)
        } else {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach(countdowns) { countdown in
                        Button {
                            withAnimation {
                                self.selectedCountdown = countdown
                            }
                        } label: {
                            CountdownSquare(countdown: countdown)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .scrollTransition { content, phase in
                                    content
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .blur(radius: phase.isIdentity ? 0 : 2)
                                }
                        }
                        .shadow(radius: 10)
                        .padding(5)
                    }
                }
                .padding()
            }
        }
    }
}
