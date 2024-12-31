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
    
    @State private var editCard: Bool = false
    
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
            if !editCard {
                Spacer(minLength: 0)
            }
            if let card = countdown.card {
                Button {
                    withAnimation {
                        self.editCard.toggle()
                    }
                } label: {
                    CountdownSquare(countdown: countdown)
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(maxWidth: min(size.width * 0.7, 400))
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }
                .shadow(radius: 10)
                .padding()
                .sheet(isPresented: $editCard) {
                    CardEditor(card: card)
                }
            }
            Spacer(minLength: 0)
//            VStack(spacing: 10) {
//                CounterDisplay(timeRemaining: countdown.timeRemaining, tintColor: countdown.currentTintColor, textStyle: countdown.currentTextStyle, textWeight: Font.Weight(rawValue: countdown.currentTextWeight), size: 37.5)
//                Text(countdown.date.fullString)
//                    .font(.title3)
//                    .fontWidth(.condensed)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                    .opacity(0.9)
//            }
//            .padding()
//            .background(Material.ultraThin.opacity(0.5))
//            .clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer(minLength: 0)
        }
        .environment(\.colorScheme, .light)
        .padding(.bottom, 50)
        .padding(.top, 80)
        .padding(20)
        .frame(width: size.width)
        .background {
            BackgroundDisplay(background: countdown.currentBackground, color: countdown.currentBackgroundColor, fade: countdown.currentBackgroundFade, blur: 20, brightness: countdown.currentBackgroundBrightness, saturation: countdown.currentBackgroundSaturation, contrast: countdown.currentBackgroundContrast, fullScreen: true)
                .overlay(Material.ultraThin)
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

