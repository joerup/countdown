//
//  CountdownGrid.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/7/23.
//

import SwiftUI
import Foundation
import SwiftData
import CountdownData
import CountdownUI

struct CountdownGrid: View {
    
    @Environment(\.modelContext) private var modelContext
    
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
    
    @State private var editing: Bool = false
    @State private var showSettings: Bool = false
    @State private var newCountdown: Countdown.DestinationType? = nil
    
    @State private var offset: CGSize = .zero
    private var offsetScale: CGFloat {
        return pow(offset.height, 2)/1E5
    }
    
    @State private var confettiTrigger: Int = 0
    
    @Namespace private var namespace
    
    var body: some View {
        Group {
            if let selectedCountdown {
                if editing {
                    CountdownEditor(countdown: selectedCountdown, editing: $editing, onDelete: { self.selectedCountdown = nil }, namespace: namespace)
                } else {
                    mainCardDisplay
                }
            } else {
                allCountdownDisplay
            }
        }
        .tint(.pink)
        .sheet(item: $newCountdown) { type in
            DestinationEditor(type: type)
        }
        .sheet(isPresented: $showSettings) {
            SettingsMenu()
        }
        .onChange(of: countdowns) { oldCountdowns, newCountdowns in
            if let countdown = newCountdowns.first(where: { !oldCountdowns.contains($0) }) {
                selectedCountdown = countdown
                editing = true
            }
        }
    }
    
    private var mainCardDisplay: some View {
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
                            cardHeaderButtons
                        }
                }
            }
        }
    }
    
    private func cardDisplay(countdown: Countdown, size: CGSize) -> some View {
        CountdownCard(countdown: countdown)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(radius: 10)
            .matchedGeometryEffect(id: countdown, in: namespace)
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
                self.offset = value.translation
                if offsetScale >= 0.7 {
                    withAnimation {
                        self.offset = .zero
                        self.selectedCountdown = nil
                    }
                }
            }
            .onEnded { value in
                withAnimation {
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
                    withAnimation {
                        if abs(offset.width) > 100 {
                            self.selectedCountdown = nil
                        }
                        self.offset = .zero
                    }
                }
            }
    }
    
    @ViewBuilder
    private var allCountdownDisplay: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        ForEach(countdowns) { countdown in
                            countdownButton(countdown: countdown) {
                                CountdownSquare(countdown: countdown)
                            }
                            .shadow(radius: 10)
                            .padding(5)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Countdowns")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                headerButtons
            }
        }
    }
    
    private func countdownButton<Content: View>(countdown: Countdown, label: @escaping () -> Content) -> some View {
        Button {
            withAnimation {
                self.selectedCountdown = countdown
            }
        } label: {
            VStack(content: label)
                .background(Color.blue.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    @ToolbarContentBuilder
    private var headerButtons: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                ForEach(Countdown.DestinationType.availableCases) { type in
                    Button(type.rawValue.capitalized) {
                        newCountdown = type
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.bold)
            }
        }
    }
    
    private var cardHeaderButtons: some View {
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
                withAnimation {
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
