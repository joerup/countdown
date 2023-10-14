//
//  CardView.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownData
import CountdownUI
import ConfettiSwiftUI

struct CardView: View {
    
    var countdown: Countdown
    
    @Binding var editing: Bool
    
    @State private var confettiTrigger: Int = 0
    
    init(countdown: Countdown) {
        self.countdown = countdown
        self._editing = .constant(false)
    }
    init(countdown: Countdown, editing: Binding<Bool>) {
        self.countdown = countdown
        self._editing = editing
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleDisplay(countdown: countdown, size: applyScale(45))
                Spacer()
                CounterDisplay(countdown: countdown, type: .full, size: applyScale(150))
            }
            .padding(.bottom, applyScale(40))
            .padding(.top, applyScale(70))
            .padding(applyScale(20))
            .frame(width: geometry.size.width)
            .background {
                BackgroundDisplay(countdown: countdown)
                    .onTapGesture {
                        if editing {
                            withAnimation {
                                editing = false
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                countdown.cycleCards()
                                countdown.startCardTimer()
                            }
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

