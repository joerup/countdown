//
//  CardView.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownData

public struct CountdownCard: View {
    
    @EnvironmentObject var clock: Clock
    
    var countdown: Countdown
    
    public init(countdown: Countdown) {
        self.countdown = countdown
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleDisplay(countdown: countdown, size: 40)
                Spacer()
                CounterDisplay(countdown: countdown, type: .full, size: 150)
            }
            .padding(.bottom, 50)
            .padding(.top, 80)
            .padding(20)
            .frame(width: geometry.size.width)
//            .confettiCannon(counter: 1, num: 100, rainHeight: 1000, openingAngle: .zero, closingAngle: .radians(2 * .pi))
            .background {
                BackgroundDisplay(countdown: countdown, icon: false)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            countdown.cycleCards()
                            countdown.startCardTimer()
                        }
                    }
            }
        }
    }
    
    private func selectButton<Content: View>(active: Bool, action: @escaping () -> Void, label: () -> Content) -> some View {
        label()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .overlay {
                if active {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.1))
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.init(white: 0.8).opacity(0.7), lineWidth: 3)
                    }
                }
            }
            .onTapGesture(perform: action)
            .disabled(!active)
    }
}

