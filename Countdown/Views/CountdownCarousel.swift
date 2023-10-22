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
    
    private var last2: Countdown? { countdown(at: -2) }
    private var last1: Countdown? { countdown(at: -1) }
    private var next1: Countdown? { countdown(at: +1) }
    private var next2: Countdown? { countdown(at: +2) }
    
    private func countdown(at relativeIndex: Int) -> Countdown? {
        if let selectedCountdown, let index = countdowns.firstIndex(of: selectedCountdown), countdowns.indices ~= index+relativeIndex {
            return countdowns[index+relativeIndex]
        }
        return nil
    }
    
    @Binding var editing: Bool
    
    @State private var offset: CGSize = .zero
    private var offsetScale: CGFloat {
        1 - pow(offset.height, 2)/1E5
    }
    private var editingScale: CGFloat {
        editing ? 0.7 : 1
    }
    private var totalScale: CGFloat {
        offsetScale * editingScale
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                carousel(size: geometry.size)
                controls(size: geometry.totalSize)
            }
            .transition(.move(edge: .bottom))
            .animation(.easeOut, value: selectedCountdown)
            .id(selectedCountdown)
        }
    }
    
    private func carousel(size: CGSize) -> some View {
        ZStack {
            if let last1 {
                cardDisplay(countdown: last1, size: size)
                    .offset(x: editingScale*(-size.width*offsetScale-15))
            }
            if let next1 {
                cardDisplay(countdown: next1, size: size)
                    .offset(x: editingScale*(size.width*offsetScale+15))
            }
            if let last2, editing {
                cardDisplay(countdown: last2, size: size)
                    .offset(x: 2*editingScale*(-size.width*offsetScale-15))
            }
            if let next2, editing {
                cardDisplay(countdown: next2, size: size)
                    .offset(x: 2*editingScale*(size.width*offsetScale+15))
            }
            if let countdown = selectedCountdown {
                cardDisplay(countdown: countdown, size: size)
            }
        }
    }
    
    private func controls(size: CGSize) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if editing, let selectedCountdown {
                    CountdownEditor(countdown: selectedCountdown, editing: $editing, onDelete: { self.selectedCountdown = nil })
                    Spacer(minLength: 0)
                } else {
                    cardButtons
                    Spacer(minLength: 0)
                }
            }
            .frame(maxHeight: .infinity)
            
            Spacer().frame(height: editing ? size.height*editingScale : nil)
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                if editing, let card = selectedCountdown?.card {
                    CardEditor(card: card)
                        .opacity(offset == .zero ? 1 : 0.5)
                        .animation(.default, value: offset)
                        .padding(.bottom)
                }
                HStack {
                    ForEach(countdowns, id: \.self) { countdown in
                        Group {
                            if editing {
                                Circle().fill(.foreground)
                            } else {
                                Circle().fill(.white)
                            }
                        }
                        .opacity(countdown == selectedCountdown ? 0.7 : 0.4)
                        .frame(width: 10)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    private func cardDisplay(countdown: Countdown, size: CGSize) -> some View {
        CountdownCard(countdown: countdown)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 10)
            .offset(offset)
            .scaleEffect(totalScale)
            .ignoresSafeArea(edges: .vertical)
            .gesture(cardGesture(size: size))
            .simultaneousGesture(TapGesture().onEnded { _ in
                if editing {
                    clock.pause {
                        editing.toggle()
                    }
                }
            })
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                UIImpactFeedbackGenerator().impactOccurred()
                clock.pause {
                    self.editing.toggle()
                }
            })
    }
    
    private func cardGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                clock.pause()
                self.offset = value.translation
                if editing {
                    offset.height = 0
                }
                if offsetScale <= 0.3 {
                    withAnimation {
                        self.offset = .zero
                        self.selectedCountdown = nil
                    }
                }
            }
            .onEnded { _ in
                clock.pause {
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
                    
                    if let last1, offset.width > 100 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            self.selectedCountdown = last1
                            self.offset = .zero
                        }
                    }
                    else if let next1, offset.width < -100 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            self.selectedCountdown = next1
                            self.offset = .zero
                        }
                    }
                    else {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            if abs(offset.width) > 100 {
                                self.selectedCountdown = nil
                                self.editing = false
                            }
                            self.offset = .zero
                        }
                    }
                }
            }
    }
    
    private var cardButtons: some View {
        HStack(spacing: 15) {
            Button {
                UIImpactFeedbackGenerator().impactOccurred()
                clock.pause {
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
                clock.pause {
                    selectedCountdown = nil
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
