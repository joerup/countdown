//
//  CountdownCarousel.swift
//  Countdown
//
//  Created by Joe Rupertus on 10/18/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownCarousel: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Clock.self) private var clock
    
    var countdowns: [Countdown]
    
    private var last2: Countdown? { countdown(at: -2) }
    private var last1: Countdown? { countdown(at: -1) }
    private var next1: Countdown? { countdown(at: +1) }
    private var next2: Countdown? { countdown(at: +2) }
    
    private func countdown(at relativeIndex: Int) -> Countdown? {
        if let selectedCountdown = clock.selectedCountdown, let index = countdowns.firstIndex(of: selectedCountdown), countdowns.indices ~= index+relativeIndex {
            return countdowns[index+relativeIndex]
        }
        return nil
    }
    
    @Binding var editing: Bool
    
    @State private var offset: CGSize = .zero
    
    @State private var disableHorizontalDrag: Bool = false
    @State private var disableVerticalDrag: Bool = false
    
    private var offsetScale: CGFloat {
        1 - min(abs(offset.height)/1000, 1)
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
            .id(clock.selectedCountdown)
        }
        .onAppear {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        .onChange(of: scenePhase) { _, phase in
            withAnimation {
                offset = .zero
            }
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
            if let countdown = clock.selectedCountdown {
                cardDisplay(countdown: countdown, isSelected: true, size: size)
            }
        }
    }
    
    private func controls(size: CGSize) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if editing, let countdown = clock.selectedCountdown {
                    CountdownEditor(countdown: countdown, editing: $editing, onDelete: {
                        withAnimation {
                            clock.select(nil)
                            self.editing = false
                        }
                    })
                    Spacer(minLength: 0)
                } else {
                    if offset == .zero {
                        cardButtons
                    }
                    Spacer(minLength: 0)
                }
            }
            .frame(maxHeight: .infinity)
            
            Spacer().frame(height: editing ? size.height*editingScale : nil)
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                if editing, let card = clock.selectedCountdown?.card {
                    CardEditor(card: card)
                        .padding(.bottom)
                    Spacer(minLength: 0)
                } else {
                    HStack {
                        ForEach(countdowns, id: \.self) { countdown in
                            Group {
                                if editing {
                                    Circle().fill(.foreground)
                                } else {
                                    Circle().fill(.white)
                                }
                            }
                            .opacity(countdown == clock.selectedCountdown ? 0.7 : 0.4)
                            .frame(width: 10)
                        }
                    }
                    .padding(.bottom, 5)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    private func cardDisplay(countdown: Countdown, isSelected: Bool = false, size: CGSize) -> some View {
        CountdownCard(countdown: countdown, isSelected: isSelected)
            .clipShape(RoundedRectangle(cornerRadius: offset == .zero && !editing ? 0 : 40))
            .shadow(radius: 10)
            .offset(offset)
            .scaleEffect(totalScale)
            .ignoresSafeArea(edges: .vertical)
            .gesture(cardGesture(size: size))
            .simultaneousGesture(TapGesture().onEnded { _ in
                if editing {
                    withAnimation {
                        editing.toggle()
                    }
                }
            })
            .simultaneousGesture(LongPressGesture().onEnded { _ in
                UIImpactFeedbackGenerator().impactOccurred()
                withAnimation {
                    self.editing.toggle()
                }
            })
    }
    
    private func cardGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                clock.pauseTickUpdates()
                
                self.offset = value.translation
                
                // reject scroll directions
                if editing || disableVerticalDrag {
                    offset.height = 0
                }
                if disableHorizontalDrag {
                    offset.width = 0
                }
                
                // prioritize single direction
                if abs(offset.height) > abs(offset.width) {
                    disableHorizontalDrag = true
                }
                if abs(offset.width) > abs(offset.height) {
                    disableVerticalDrag = true
                }
                // dismiss if scrolled far enough vertically
                if offsetScale <= 0.3 {
                    withAnimation {
                        self.offset = .zero
                        clock.select(nil)
                    }
                }
            }
            .onEnded { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + clock.delay) {
                    clock.resumeTickUpdates()
                }
                disableHorizontalDrag = false
                disableVerticalDrag = false
                
                withAnimation(.easeInOut(duration: clock.delay)) {
                    if abs(offset.height) > 100 {
                        clock.select(nil)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + clock.delay) {
                        clock.select(last1)
                        self.offset = .zero
                    }
                }
                else if let next1, offset.width < -100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + clock.delay) {
                        clock.select(next1)
                        self.offset = .zero
                    }
                }
                else {
                    withAnimation(.easeInOut(duration: clock.delay)) {
                        if abs(offset.width) > 100 {
                            clock.select(nil)
                            self.editing = false
                        }
                        self.offset = .zero
                    }
                }
            }
    }
    
    private var cardButtons: some View {
        HStack(spacing: 15) {
            Button {
                UIImpactFeedbackGenerator().impactOccurred()
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
                withAnimation {
                    clock.select(nil)
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
