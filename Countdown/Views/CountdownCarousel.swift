//
//  CountdownCarousel.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 10/18/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownCarousel: View {
    
    @EnvironmentObject var clock: Clock
    
    var countdowns: [Countdown]
    
    @Binding var selectedCountdown: Countdown?
    
    private var previousCountdown: Countdown? {
        if let selectedCountdown, let index = countdowns.firstIndex(of: selectedCountdown), countdowns.indices ~= index-1 {
            return countdowns[index-1]
        }
        return nil
    }
    private var nextCountdown: Countdown? {
        if let selectedCountdown, let index = countdowns.firstIndex(of: selectedCountdown), countdowns.indices ~= index+1 {
            return countdowns[index+1]
        }
        return nil
    }
    
    @Binding var editing: Bool
    
    @State private var offset: CGSize = .zero
    private var offsetScale: CGFloat {
        return pow(offset.height, 2)/1E5
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let previousCountdown, offset.width > 50 {
                    cardDisplay(countdown: previousCountdown, size: geometry.size)
                        .offset(x: -geometry.size.width*(1-offsetScale)-15)
                        .opacity((offset.width-50)/(geometry.size.width-50))
                }
                if let nextCountdown, offset.width < -50 {
                    cardDisplay(countdown: nextCountdown, size: geometry.size)
                        .offset(x: geometry.size.width*(1-offsetScale)+15)
                        .opacity((-offset.width-50)/(geometry.size.width-50))
                }
                if let countdown = selectedCountdown {
                    cardDisplay(countdown: countdown, size: geometry.size)
                        .opacity(1.0-abs(offset.width)/geometry.size.width)
                        .overlay(alignment: .bottom) {
                            if abs(offset.height) < 10 {
                                HStack {
                                    ForEach(countdowns, id: \.self) { countdown in
                                        Circle().fill(.white)
                                            .opacity(countdown == selectedCountdown ? 1 : 0.5)
                                            .frame(width: 10)
                                    }
                                }
                            }
                        }
                        .overlay(alignment: .top) {
                            headerButtons
                        }
                }
            }
            .transition(.move(edge: .bottom))
            .animation(.easeOut, value: selectedCountdown)
            .id(selectedCountdown)
        }
    }
    
    private func cardDisplay(countdown: Countdown, size: CGSize) -> some View {
        CountdownCard(countdown: countdown)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 10)
            .offset(offset)
            .scaleEffect(1-offsetScale)
            .ignoresSafeArea(edges: .vertical)
            .gesture(cardGesture(size: size))
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                withAnimation {
                    self.editing.toggle()
                }
            })
    }
    
    private func cardGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                clock.pause()
                self.offset = value.translation
                if offsetScale >= 0.7 {
                    withAnimation {
                        self.offset = .zero
                        self.selectedCountdown = nil
                    }
                }
            }
            .onEnded { value in
                withAnimation(.easeInOut(duration: 0.35)) {
                    if abs(offset.height) > 100 {
                        self.selectedCountdown = nil
                    }
                    else if offset.width > 100 {
                        self.offset.width = size.width+15
                    }
                    else if offset.width < -100 {
                        self.offset.width = -size.width-15
                    }
                    else {
                        self.offset.width = 0
                    }
                    self.offset.height = 0
                }
                
                if let previousCountdown, offset.width > 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.selectedCountdown = previousCountdown
                        self.offset = .zero
                    }
                }
                else if let nextCountdown, offset.width < -100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        self.selectedCountdown = nextCountdown
                        self.offset = .zero
                    }
                }
                else {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        if abs(offset.width) > 100 {
                            self.selectedCountdown = nil
                        }
                        self.offset = .zero
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    clock.start()
                }
            }
    }
    
    private var headerButtons: some View {
        HStack(spacing: 15) {
            Button {
                withAnimation {
                    editing.toggle()
                }
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .imageScale(.large)
                    .opacity(0.5)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            Spacer()
            Button {
                clock.pause()
                withAnimation(.easeInOut(duration: 0.35)) {
                    selectedCountdown = nil
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    clock.start()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .opacity(0.5)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
        }
        .tint(.white)
    }
}
