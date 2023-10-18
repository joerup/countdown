//
//  CardView.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownData
import ConfettiSwiftUI

public struct CountdownCard: View {
    
    var countdown: Countdown
    var editing: Bool
    
    @State private var confettiTrigger: Int = 0
    
    public init(countdown: Countdown, editing: Bool = false) {
        self.countdown = countdown
        self.editing = editing
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleDisplay(countdown: countdown, size: applyScale(45))
                Spacer()
                CounterDisplay(countdown: countdown, type: .full, size: applyScale(150))
            }
            .padding(.bottom, applyScale(50))
            .padding(.top, applyScale(70))
            .padding(applyScale(20))
            .frame(width: geometry.size.width)
            .background {
                BackgroundDisplay(countdown: countdown)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            countdown.cycleCards()
                            countdown.startCardTimer()
                        }
                    }
            }
        }
    }
    
    private func applyScale(_ value: CGFloat) -> CGFloat {
        return editing ? 0.75 * value : value
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

