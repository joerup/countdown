//
//  CardView.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownUI
import CountdownData
import ConfettiSwiftUI

public struct CountdownCard: View {
    
    @Environment(Clock.self) private var clock
    @Environment(\.scenePhase) private var scenePhase
    
    private var countdown: Countdown
    private var isSelected: Bool
    private var size: CGSize
    
    private var animation: Namespace.ID
    
    @State private var confettiCannonReady: Bool = true
    @State private var confettiTrigger: Int = 1
    
    public init(countdown: Countdown, isSelected: Bool = false, size: CGSize, animation: Namespace.ID) {
        self.countdown = countdown
        self.isSelected = isSelected
        self.size = size
        self.animation = animation
    }
    
    public var body: some View {
        VStack {
            Spacer(minLength: 0)
            CountdownSquare(countdown: countdown)
                .aspectRatio(1.0, contentMode: .fit)
                .frame(maxWidth: min(size.width * 0.7, 400))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(radius: 10)
                .padding()
            if let card = countdown.card {
                CardEditor(card: card)
            }
            Spacer(minLength: 0)
            CounterDisplay(timeRemaining: countdown.timeRemaining, tintColor: countdown.currentTintColor, size: 37.5)
        }
        .padding(.bottom, 50)
        .padding(.top, 80)
        .padding(20)
        .frame(width: size.width)
        .background {
            BackgroundDisplay(background: countdown.currentBackground, blurRadius: 10)
                .opacity(0.75)
                .id(clock.tick)
        }
        .confettiCannon(counter: $confettiTrigger, num: 100, colors: countdown.currentTintColor.discretizedGradient(numberOfShades: 10), rainHeight: 1.5 * size.height, radius: 0.7 * max(size.height, size.width))
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

