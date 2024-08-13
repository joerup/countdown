//
//  CardView.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownData
import ConfettiSwiftUI

public struct CountdownCard: View {
    
    @Environment(Clock.self) private var clock
    
    private var countdown: Countdown
    
    public init(countdown: Countdown) {
        self.countdown = countdown
    }
    
    @State private var confetti: Int = 1
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleDisplay(title: countdown.displayName, date: countdown.dateString, tintColor: countdown.currentTintColor, size: 40)
                Spacer()
                VStack(spacing: 0) {
                    DaysDisplay(daysRemaining: countdown.daysRemaining, tintColor: countdown.currentTintColor, textStyle: countdown.currentTextStyle, size: 150)
                    CounterDisplay(timeRemaining: countdown.timeRemaining, tintColor: countdown.currentTintColor, textStyle: countdown.currentTextStyle, size: 37.5)
                }
            }
            .id(clock.tick)
            .padding(.bottom, 50)
            .padding(.top, 80)
            .padding(20)
            .frame(width: geometry.size.width)
            .background {
                BackgroundDisplay(background: countdown.currentBackground)
            }
            .confettiCannon(counter: $confetti, num: 100, colors: countdown.currentTintColor.discretizedGradient(numberOfShades: 10), rainHeight: 1.5 * geometry.size.height, radius: 0.7 * max(geometry.size.height, geometry.size.width))
            .onAppear {
                if countdown.isComplete && countdown.isToday {
                    confetti += 1
                }
            }
            .onChange(of: countdown.isComplete) { _, isComplete in
                if isComplete && countdown.isToday {
                    confetti += 1
                }
            }
        }
    }
}

