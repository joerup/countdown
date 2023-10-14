//
//  CountdownList.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/7/23.
//

import SwiftUI
import Foundation
import SwiftData
import CountdownData
import CountdownUI

struct CountdownList: View {
    
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
    @State private var newCountdown: Countdown.DestinationType? = nil
    
    @AppStorage("displayType") private var displayType: DisplayType = .grid
    
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
                    CardEditor(countdown: selectedCountdown, editing: $editing, namespace: namespace)
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
        .onChange(of: countdowns) { oldCountdowns, newCountdowns in
            if newCountdowns.count > oldCountdowns.count {
                selectedCountdown = newCountdowns.last
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
                }
            }
            .overlay(alignment: .top) {
                cardHeaderButtons
            }
        }
    }
    
    private func cardDisplay(countdown: Countdown, size: CGSize) -> some View {
        CardView(countdown: countdown)
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
                withAnimation(.easeInOut(duration: 0.35)) {
                    if offset.height > 100 {
                        self.selectedCountdown = nil
                    }
                    else if offset.height < -100 {
                        self.editing.toggle()
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
        switch displayType {
        case .list:
            VStack {
                headerButtons
                ScrollView {
                    VStack {
                        ForEach(countdowns) { countdown in
                            countdownButton(countdown: countdown) {
                                CountdownRow(countdown: countdown)
                            }
                        }
                    }
                    .padding()
                }
            }
        case .grid:
            VStack {
                headerButtons
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        ForEach(countdowns) { countdown in
                            countdownButton(countdown: countdown) {
                                CountdownSquare(countdown: countdown)
                            }
                        }
                    }
                    .padding()
                }
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
                .matchedGeometryEffect(id: countdown, in: namespace)
                .contextMenu {
                    Button {
                        modelContext.delete(countdown)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .background(Color.blue.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var headerButtons: some View {
        HStack(spacing: 15) {
            Button {
                
            } label: {
                Image(systemName: "gearshape.fill")
            }
            
            Spacer()
            
            ForEach(DisplayType.allCases, id: \.self) { type in
                Button {
                    withAnimation {
                        displayType = type
                    }
                } label: {
                    Image(systemName: type.icon)
                        .foregroundColor(selectedCountdown != nil && !editing ? .white : displayType == type ? .pink : .gray)
                }
            }
            
            Spacer()
            
            Menu {
                ForEach(Countdown.DestinationType.allCases) { type in
                    Button(type.rawValue.capitalized) {
                        newCountdown = type
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }
        }
        .padding(.horizontal)
        .padding(.top, 5)
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
            }
        }
        .tint(.white)
        .padding(.horizontal)
        .padding(.top, 5)
    }
    
    enum DisplayType: String, CaseIterable {
        case list
        case grid
        
        var icon: String {
            switch self {
            case .list:
                "rectangle.grid.1x2"
            case .grid:
                "square.grid.2x2"
            }
        }
    }
}
