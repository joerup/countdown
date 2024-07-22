//
//  CardView.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownData

public struct CountdownCard: View {
    
    @Environment(Clock.self) private var clock
    
    private var countdown: Countdown
    
    public init(countdown: Countdown) {
        self.countdown = countdown
    }
    
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
//            .confettiCannon(counter: 1, num: 100, rainHeight: 1000, openingAngle: .zero, closingAngle: .radians(2 * .pi))
            .background {
                BackgroundDisplay(background: countdown.currentBackground)
            }
        }
    }
}

