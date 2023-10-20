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
    
    @EnvironmentObject var clock: Clock
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: horizontalSizeClass == .compact ? 2 : 4)) {
                    ForEach(countdowns) { countdown in
                        Button {
                            clock.pause()
                            withAnimation(.easeInOut(duration: 0.35)) {
                                self.selectedCountdown = countdown
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                clock.start()
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
