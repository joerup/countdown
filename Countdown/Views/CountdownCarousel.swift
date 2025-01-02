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
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var countdowns: [Countdown]
    
    private var last: Countdown? { countdown(at: -1) }
    private var next: Countdown? { countdown(at: +1) }
    
    private func countdown(at relativeIndex: Int) -> Countdown? {
        if let selectedCountdown = clock.selectedCountdown, let index = countdowns.firstIndex(of: selectedCountdown), countdowns.indices ~= index+relativeIndex {
            return countdowns[index+relativeIndex]
        }
        return nil
    }
    
    @State private var offset: CGSize = .zero
    @Binding var editingCountdown: Countdown?
    
    func isEditing(_ countdown: Countdown) -> Bool {
        countdown == self.editingCountdown
    }
    func editingCountdownWrapper(_ countdown: Countdown) -> Binding<Bool> {
        Binding(get: {
            isEditing(countdown)
        }, set: { value in
            self.editingCountdown = value ? countdown : nil
        })
    }
    
    @State private var disableHorizontalDrag: Bool = false
    @State private var disableVerticalDrag: Bool = false
    
    @State private var confettiCannonReady: Bool = true
    @State private var confettiTrigger: Int = 1
    
    private var scale: CGFloat {
        1 - min(abs(offset.height)/1000, 1)
    }
    
    private var showMultipleCards: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    private let idealCardAspectRatio: CGFloat = 19.5/9
    
    private var carouselGapWidth: CGFloat {
        showMultipleCards ? 15 : 10
    }
    private var cardPadding: CGFloat {
        showMultipleCards ? 20 : 0
    }
    
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            let cardSize = cardSize(from: geometry.size)
            let edgeInsets = geometry.safeAreaInsets
            Group {
                if showMultipleCards {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(countdowns) { countdown in
                                cardDisplay(countdown: countdown, size: cardSize, edgeInsets: edgeInsets)
                            }
                        }
                        .padding(cardPadding)
                    }
                    .overlay(alignment: .topTrailing) {
                        Button {
                            withAnimation {
                                clock.select(nil)
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(.foreground)
                                .opacity(0.8)
                        }
                        .padding()
                    }
                } else {
                    ZStack {
                        if let last {
                            cardDisplay(countdown: last, size: cardSize, edgeInsets: edgeInsets)
                                .offset(x: -cardSize.width * scale - carouselGapWidth)
                        }
                        if let next {
                            cardDisplay(countdown: next, size: cardSize, edgeInsets: edgeInsets)
                                .offset(x: cardSize.width * scale + carouselGapWidth)
                        }
                        if let countdown = clock.selectedCountdown {
                            cardDisplay(countdown: countdown, size: cardSize, edgeInsets: edgeInsets)
                                .frame(maxWidth: cardSize.width)
                        }
                    }
                    .padding(cardPadding)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .id(clock.selectedCountdown)
            .confettiCannon(counter: $confettiTrigger, num: 100, colors: (clock.selectedCountdown?.currentTintColor ?? .white).discretizedGradient(numberOfShades: 10), rainHeight: 1.5 * geometry.size.height, radius: 0.7 * max(geometry.size.height, geometry.size.width))
            .overlay(alignment: .bottom) {
                footer
            }
        }
        .onAppear {
            UIImpactFeedbackGenerator().impactOccurred()
            shootConfetti()
        }
        .onChange(of: scenePhase) { _, phase in
            withAnimation {
                offset = .zero
            }
            if case .active = phase {
                shootConfetti()
            }
        }
        .onChange(of: clock.selectedCountdown?.isComplete) { _, _ in
            shootConfetti()
        }
    }
    
    private func cardSize(from geometrySize: CGSize) -> CGSize {
        if showMultipleCards {
            var width = geometrySize.width - 2 * cardPadding
            let height = geometrySize.height - 2 * cardPadding
            width = min(width, height / idealCardAspectRatio)
            return CGSize(width: width, height: height)
        } else {
            return geometrySize
        }
    }
    
    private func cardDisplay(countdown: Countdown, size: CGSize, edgeInsets: EdgeInsets) -> some View {
        CountdownCard(countdown: countdown, size: size, edgeInsets: edgeInsets, fullScreen: !showMultipleCards, animation: animation, editCard: editingCountdownWrapper(countdown))
            .shadow(radius: 10)
            .offset(offset)
            .scaleEffect(scale)
            .gesture(isEditing(countdown) || showMultipleCards ? nil : cardGesture(size: size))
            .onTapGesture {
                shootConfetti()
            }
    }
    
    private var footer: some View {
        HStack {
            ForEach(countdowns, id: \.self) { countdown in
                Group {
                    Circle().fill(.white)
                }
                .opacity(countdown == clock.selectedCountdown ? 0.7 : 0.4)
                .frame(width: 10)
                .onTapGesture {
                    clock.select(countdown)
                }
            }
        }
        .padding(.bottom, 5)
    }
    
    private func shootConfetti() {
        guard confettiCannonReady, let countdown = clock.selectedCountdown, !isEditing(countdown), countdown.isComplete, countdown.isToday else { return }
        confettiTrigger += 1
        confettiCannonReady = false
        UIImpactFeedbackGenerator().impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            confettiCannonReady = true
        }
    }
    
    private func cardGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                clock.pauseTickUpdates()
                
                self.offset = value.translation
                
                // reject scroll directions
                if disableVerticalDrag {
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
                if scale <= 0.3 {
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
                        self.offset.width = size.width + carouselGapWidth
                    }
                    else if offset.width < -100 {
                        self.offset.width = -size.width - carouselGapWidth
                    }
                    else {
                        self.offset.width = 0
                    }
                    self.offset.height = 0
                }
                
                if let last, offset.width > 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + clock.delay) {
                        clock.select(last)
                        self.offset = .zero
                    }
                }
                else if let next, offset.width < -100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + clock.delay) {
                        clock.select(next)
                        self.offset = .zero
                    }
                }
                else {
                    withAnimation(.easeInOut(duration: clock.delay)) {
                        if abs(offset.width) > 100 {
                            clock.select(nil)
                        }
                        self.offset = .zero
                    }
                }
            }
    }
}
