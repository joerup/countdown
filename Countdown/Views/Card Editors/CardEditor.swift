//
//  CardEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 10/21/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CardEditor: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss
    
    var card: Card
    
    @State private var section: CardEditorSection = .layout
    
    private enum CardEditorSection: String, CaseIterable, Hashable {
        case layout, background, text
    }
    
    @State private var savedInstance: CountdownInstance?
    @State private var savedBackgroundData: Card.BackgroundData?
    
    @State private var tintColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Int = Font.Weight.medium.rawValue
    @State private var textOpacity: Double = 1.0
    @State private var textShadow: Double = 0
    
    @State private var backgroundColor: Color = .white
    @State private var backgroundFade: Double = 0
    @State private var backgroundBlur: Double = 0
    @State private var backgroundSaturation: Double = 0
    @State private var backgroundBrightness: Double = 0
    @State private var backgroundContrast: Double = 0
    
    @State private var layout: Card.Layout = .basic
    
    private var title: String {
        card.countdown?.displayName ?? "Countdown"
    }
    private var dateString: String {
        card.countdown?.dateString ?? ""
    }
    private var daysRemaining: Int {
        card.countdown?.daysRemaining ?? 0
    }
    private var timeRemaining: Date.TimeRemaining {
        card.countdown?.timeRemaining ?? .zero
    }
    private var background: Card.Background? {
        card.countdown?.currentBackground
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    if let instance = savedInstance {
                        card.countdown?.match(instance)
                        setStates()
                        setBackground(savedBackgroundData)
                    }
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward.circle")
                        .imageScale(.large)
                        .foregroundStyle(.foreground)
                }
                
                Picker("", selection: $section) {
                    ForEach(CardEditorSection.allCases, id: \.self) { section in
                        Text(section.rawValue.capitalized).tag(section)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.foreground)
                }
            }
            .padding()
            
            Divider()
            
            ScrollView {
                Group {
                    switch section {
                    case .layout:
                        LayoutEditor(layout: $layout, title: title, dateString: dateString, daysRemaining: daysRemaining, timeRemaining: timeRemaining, tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity)
                    case .background:
                        BackgroundEditor(background: background, backgroundData: card.backgroundData, backgroundColor: $backgroundColor, backgroundFade: $backgroundFade, backgroundBlur: $backgroundBlur, backgroundSaturation: $backgroundSaturation, backgroundBrightness: $backgroundBrightness, backgroundContrast: $backgroundContrast, setBackground: setBackground(_:))
                    case .text:
                        TextStyleEditor(textStyle: $textStyle, textWeight: $textWeight, tintColor: $tintColor, textOpacity: $textOpacity)
                    }
                }
                .safeAreaPadding()
            }
        }
        .presentationBackground(Material.ultraThin)
        .presentationDetents([.height(450)])
        .presentationCornerRadius(20)
        .onAppear {
            setStates()
            if let countdown = card.countdown {
                savedInstance = CountdownInstance(from: countdown)
                savedBackgroundData = card.backgroundData
            }
        }
        .onChange(of: tintColor) { _, color in
            card.tintColor = color
            saveCard()
        }
        .onChange(of: textStyle) { _, style in
            card.textStyle = style
            saveCard()
        }
        .onChange(of: textWeight) { _, weight in
            card.textWeight = weight
            saveCard()
        }
        .onChange(of: textOpacity) { _, opacity in
            card.textOpacity = opacity
            saveCard()
        }
        .onChange(of: textShadow) { _, shadow in
            card.textShadow = shadow
            saveCard()
        }
        .onChange(of: backgroundColor) { _, color in
            card.backgroundColor = color
            saveCard()
        }
        .onChange(of: backgroundFade) { _, fade in
            card.backgroundFade = fade
            saveCard()
        }
        .onChange(of: backgroundBlur) { _, blur in
            card.backgroundBlur = blur
            saveCard()
        }
        .onChange(of: backgroundSaturation) { _, saturation in
            card.backgroundSaturation = saturation
            saveCard()
        }
        .onChange(of: backgroundBrightness) { _, brightness in
            card.backgroundBrightness = brightness
            saveCard()
        }
        .onChange(of: backgroundContrast) { _, contrast in
            card.backgroundContrast = contrast
            saveCard()
        }
        .onChange(of: layout) { _, layout in
            card.layout = layout
            saveCard()
        }
    }
    
    private func setStates() {
        tintColor = card.tintColor
        textStyle = card.textStyle
        textWeight = card.textWeight
        textOpacity = card.textOpacity
        textShadow = card.textShadow
        backgroundColor = card.backgroundColor
        backgroundFade = card.backgroundFade
        backgroundBlur = card.backgroundBlur
        backgroundContrast = card.backgroundContrast
        backgroundSaturation = card.backgroundSaturation
        backgroundBrightness = card.backgroundBrightness
        layout = card.layout ?? .basic
    }
    
    private func setBackground(_ data: Card.BackgroundData?) {
        card.setBackground(data)
        UIImpactFeedbackGenerator().impactOccurred()
        saveCard(reload: true)
    }
    
    private func saveCard(reload: Bool = false) {
        if reload, card == card.countdown?.card {
            Task {
                await card.countdown?.loadCards()
            }
        }
        try? modelContext.save()
    }
}