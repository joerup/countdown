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
    @Environment(\.scenePhase) private var scenePhase
    
    private var countdown: Countdown
    private var isSelected: Bool
    
    @State private var confettiCannonReady: Bool = true
    @State private var confettiTrigger: Int = 1
    
    public init(countdown: Countdown, isSelected: Bool = false) {
        self.countdown = countdown
        self.isSelected = isSelected
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleDisplay(title: countdown.displayName, date: countdown.dateString, tintColor: countdown.currentTintColor, size: 40)
                Spacer()
                VStack(spacing: 0) {
                    DaysDisplay(daysRemaining: countdown.daysRemaining, tintColor: countdown.currentTintColor, textStyle: countdown.currentTextStyle, size: 150)
                    CounterDisplay(timeRemaining: countdown.timeRemaining, tintColor: countdown.currentTintColor, size: 37.5)
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
            .confettiCannon(counter: $confettiTrigger, num: 100, colors: countdown.currentTintColor.discretizedGradient(numberOfShades: 10), rainHeight: 1.5 * geometry.size.height, radius: 0.7 * max(geometry.size.height, geometry.size.width))
            .onAppear {
                shootConfetti()
            }
            .onTapGesture {
                shootConfetti()
            }
            .onChange(of: countdown.isComplete) { _, _ in
                shootConfetti()
            }
            .onChange(of: scenePhase) { _, phase in
                if case .active = phase {
                    shootConfetti()
                }
            }
        }
    }
    
    private func shootConfetti() {
        guard confettiCannonReady, isSelected else { return }
        guard countdown.isComplete && countdown.isToday else { return }
        confettiTrigger += 1
        confettiCannonReady = false
        UIImpactFeedbackGenerator().impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            confettiCannonReady = true
        }
    }
}

