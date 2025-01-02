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
    
    var card: Card
    
    var edgeInsets: EdgeInsets
    
    var dismiss: () -> Void
    
    @State private var section: CardEditorSection = .background
    
    private enum CardEditorSection: String, CaseIterable, Hashable {
        case background, text
    }
    
    @State private var savedInstance: CountdownInstance?
    @State private var savedBackgroundData: Card.BackgroundData?
    
    @State private var tintColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Int = Font.Weight.medium.rawValue
    @State private var textOpacity: Double = 1.0
    @State private var textShadow: Double = 0
    @State private var titleSize: Double = 1.0
    @State private var numberSize: Double = 1.0
    
    @State private var backgroundTransform: Card.ImageTransform?
    @State private var backgroundColor: Color?
    @State private var backgroundFade: Double = 0
    @State private var backgroundBlur: Double = 0
    @State private var backgroundSaturation: Double = 0
    @State private var backgroundBrightness: Double = 0
    @State private var backgroundContrast: Double = 0
    
    @State private var forceUpdate: Bool = false
    
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
    private var backgroundIcon: Card.Background? {
        card.countdown?.currentBackgroundIcon
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    if let instance = savedInstance {
                        card.countdown?.match(instance)
                        setStates()
                        setBackground(savedBackgroundData, transform: backgroundTransform, resetStates: false)
                    }
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward.circle")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                }
                
                Picker("", selection: $section) {
                    ForEach(CardEditorSection.allCases, id: \.self) { section in
                        Text(section.rawValue.capitalized).tag(section)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 8)
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                }
            }
            .padding()
            
            Divider()
            
            ScrollView {
                Group {
                    switch section {
                    case .background:
                        BackgroundEditor(background: background, backgroundData: card.backgroundData, backgroundIcon: backgroundIcon, backgroundIconData: card.backgroundIconData, backgroundTransform: backgroundTransform, backgroundColor: $backgroundColor, backgroundFade: $backgroundFade, backgroundBlur: $backgroundBlur, backgroundSaturation: $backgroundSaturation, backgroundBrightness: $backgroundBrightness, backgroundContrast: $backgroundContrast) { background, transform, resetStates in
                            setBackground(background, transform: transform, resetStates: resetStates)
                        }
                        .id(forceUpdate)
                    case .text:
                        TextStyleEditor(textStyle: $textStyle, textWeight: $textWeight, tintColor: $tintColor, textOpacity: $textOpacity, titleSize: $titleSize, numberSize: $numberSize)
                    }
                }
                .safeAreaPadding(.bottom, edgeInsets.bottom)
                .safeAreaPadding()
            }
        }
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
        .onChange(of: titleSize) { _, size in
            card.titleSize = size
            saveCard()
        }
        .onChange(of: numberSize) { _, size in
            card.numberSize = size
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
    }
    
    private func setStates() {
        backgroundTransform = card.backgroundTransformSquare
        tintColor = card.tintColor
        textStyle = card.textStyle
        textWeight = card.textWeight
        textOpacity = card.textOpacity
        textShadow = card.textShadow
        titleSize = card.titleSize
        numberSize = card.numberSize
        backgroundColor = card.backgroundColor
        backgroundFade = card.backgroundFade
        backgroundBlur = card.backgroundBlur
        backgroundContrast = card.backgroundContrast
        backgroundSaturation = card.backgroundSaturation
        backgroundBrightness = card.backgroundBrightness
    }
    
    private func setBackground(_ data: Card.BackgroundData?, transform: Card.ImageTransform?, resetStates: Bool) {
        card.backgroundTransformSquare = transform
        backgroundTransform = transform
        card.setBackground(data)
        UIImpactFeedbackGenerator().impactOccurred()
        saveCard(reload: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            forceUpdate.toggle()
        }
        if resetStates {
            backgroundColor = nil
            backgroundFade = 0.4
            backgroundBlur = 0
            backgroundBrightness = 0
            backgroundSaturation = 1.0
            backgroundContrast = 1.0
        }
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
