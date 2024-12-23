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
    
    private var last: Countdown? { countdown(at: -1) }
    private var next: Countdown? { countdown(at: +1) }
    
    private func countdown(at relativeIndex: Int) -> Countdown? {
        if let selectedCountdown = clock.selectedCountdown, let index = countdowns.firstIndex(of: selectedCountdown), countdowns.indices ~= index+relativeIndex {
            return countdowns[index+relativeIndex]
        }
        return nil
    }
    
    @State private var editDestination = false
    @State private var shareCountdown = false
    @State private var deleteCountdown = false
    
    @State private var offset: CGSize = .zero
    
    @State private var disableHorizontalDrag: Bool = false
    @State private var disableVerticalDrag: Bool = false
    
    private var scale: CGFloat {
        1 - min(abs(offset.height)/1000, 1)
    }
    
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let last {
                    cardDisplay(countdown: last, size: geometry.size)
                        .offset(x: -geometry.size.width * scale - 15)
                }
                if let next {
                    cardDisplay(countdown: next, size: geometry.size)
                        .offset(x: geometry.size.width * scale + 15)
                }
                if let countdown = clock.selectedCountdown {
                    cardDisplay(countdown: countdown, isSelected: true, size: geometry.size)
                        .frame(maxWidth: geometry.size.width)
                }
            }
            .id(clock.selectedCountdown)
            .overlay(alignment: .top) {
                header
            }
            .overlay(alignment: .bottom) {
                footer
            }
        }
        .onAppear {
            UIImpactFeedbackGenerator().impactOccurred()
        }
        .onChange(of: scenePhase) { _, phase in
            withAnimation {
                offset = .zero
            }
        }
        .sheet(isPresented: $editDestination) {
            if let countdown = clock.selectedCountdown {
                OccasionEditor(countdown: countdown)
            }
        }
        .sheet(isPresented: $shareCountdown) {
            if let countdown = clock.selectedCountdown {
                ShareMenu(countdown: countdown)
            }
        }
        .alert("Delete Countdown", isPresented: $deleteCountdown) {
            Button("Cancel", role: .cancel) {
                deleteCountdown = false
            }
            Button("Delete", role: .destructive) {
                if let countdown = clock.selectedCountdown {
                    clock.delete(countdown)
                    clock.select(nil)
                }
            }
        } message: {
            Text("Are you sure you want to delete this countdown? This action cannot be undone.")
        }
    }
    
    private func cardDisplay(countdown: Countdown, isSelected: Bool = false, size: CGSize) -> some View {
        CountdownCard(countdown: countdown, isSelected: isSelected, size: size, animation: animation)
            .clipShape(RoundedRectangle(cornerRadius: offset == .zero ? 0 : 40))
            .shadow(radius: 10)
            .offset(offset)
            .scaleEffect(scale)
            .ignoresSafeArea(edges: .vertical)
            .gesture(cardGesture(size: size))
    }
    
    @ViewBuilder
    private var header: some View {
        if let countdown = clock.selectedCountdown {
            HStack {
                Button {
                    editDestination.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .opacity(0.5)
                        .padding(5)
                }
                .tint(.white)
                
                Button {
                    deleteCountdown.toggle()
                } label: {
                    Image(systemName: "trash")
                        .opacity(0.5)
                        .padding(5)
                }
                .tint(.white)
                
                Spacer()
                
                Button {
                    withAnimation {
                        clock.select(nil)
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .opacity(0.5)
                        .padding(5)
                }
                .tint(.white)
            }
            .overlay {
                Text(countdown.displayName)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .opacity(0.8)
            }
            .padding(.horizontal)
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
            }
        }
        .padding(.bottom, 5)
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
