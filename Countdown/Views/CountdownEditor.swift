//
//  CountdownEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 1/3/25.
//

import SwiftUI
import CountdownUI
import SwiftData
import CountdownData

struct CountdownEditor: View {
    
    @Environment(Clock.self) private var clock
    
    private var countdown: Countdown
    
    @Binding private var isEditing: Bool
    
    @State private var section: CardEditorSection = .countdown
    
    private enum CardEditorSection: String, CaseIterable, Hashable {
        case countdown, background, text
    }
    
    @State private var cancelAlert: Bool = false
    
    private var sheetHeight: CGFloat
    
    @State private var editedCountdown: CountdownInstance
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var occasion: Occasion?
    @State private var type: EventType = .custom
    
    @State private var backgroundColor: Color?
    @State private var backgroundFade: Double = 0
    @State private var backgroundBlur: Double = 0
    @State private var backgroundSaturation: Double = 0
    @State private var backgroundBrightness: Double = 0
    @State private var backgroundContrast: Double = 0
    
    @State private var textColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Int = Font.Weight.medium.rawValue
    @State private var textOpacity: Double = 1.0
    @State private var textShadow: Double = 0
    @State private var titleSize: Double = 1.0
    @State private var numberSize: Double = 1.0
    
    init(countdown: Countdown, isEditing: Binding<Bool>, sheetHeight: CGFloat) {
        self.countdown = countdown
        self._editedCountdown = State(initialValue: CountdownInstance(from: countdown))
        self._isEditing = isEditing
        self.sheetHeight = sheetHeight
    }
    
    var body: some View {
        Group {
            VStack {
                header
                    .padding()
                
                CountdownSquare(instance: editedCountdown)
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .padding(.top, -30)
                    .padding(.bottom, 12)
                
                VStack(spacing: 0) {
                    sectionPicker
                        .padding()
                    Divider()
                    editorContent
                }
                .frame(height: sheetHeight)
                .background(Material.ultraThin)
                .transition(.move(edge: .bottom))
                .ignoresSafeArea(edges: .vertical)
            }
            .background {
                BackgroundDisplay(background: editedCountdown.currentBackground?.full, color: backgroundColor, fade: backgroundFade, blur: backgroundBlur, brightness: backgroundBrightness, saturation: backgroundSaturation, contrast: backgroundContrast)
                    .overlay(Material.ultraThin)
            }
            .onAppear {
                name = editedCountdown.name
                displayName = editedCountdown.displayName
                occasion = editedCountdown.occasion
                type = editedCountdown.type
                textColor = editedCountdown.textColor
                textStyle = editedCountdown.textStyle
                textWeight = editedCountdown.textWeight
                textOpacity = editedCountdown.textOpacity
                textShadow = editedCountdown.textShadow
                titleSize = editedCountdown.titleSize
                numberSize = editedCountdown.numberSize
                backgroundColor = editedCountdown.backgroundColor
                backgroundFade = editedCountdown.backgroundFade
                backgroundBlur = editedCountdown.backgroundBlur
                backgroundSaturation = editedCountdown.backgroundSaturation
                backgroundBrightness = editedCountdown.backgroundBrightness
                backgroundContrast = editedCountdown.backgroundContrast
            }
            .onChange(of: name) { _, name in
                editedCountdown.name = name
            }
            .onChange(of: displayName) { _, name in
                editedCountdown.displayName = name
            }
            .onChange(of: occasion) { _, occasion in
                editedCountdown.occasion = occasion ?? .now
            }
            .onChange(of: type) { _, type in
                editedCountdown.type = type
            }
        }
        .onChange(of: textColor) { _, color in
            editedCountdown.textColor = color
        }
        .onChange(of: textStyle) { _, style in
            editedCountdown.textStyle = style
        }
        .onChange(of: textWeight) { _, weight in
            editedCountdown.textWeight = weight
        }
        .onChange(of: textOpacity) { _, opacity in
            editedCountdown.textOpacity = opacity
        }
        .onChange(of: textShadow) { _, shadow in
            editedCountdown.textShadow = shadow
        }
        .onChange(of: titleSize) { _, size in
            editedCountdown.titleSize = size
        }
        .onChange(of: numberSize) { _, size in
            editedCountdown.numberSize = size
        }
        .onChange(of: backgroundColor) { _, color in
            editedCountdown.backgroundColor = color
        }
        .onChange(of: backgroundFade) { _, fade in
            editedCountdown.backgroundFade = fade
        }
        .onChange(of: backgroundBlur) { _, blur in
            editedCountdown.backgroundBlur = blur
        }
        .onChange(of: backgroundSaturation) { _, saturation in
            editedCountdown.backgroundSaturation = saturation
        }
        .onChange(of: backgroundBrightness) { _, brightness in
            editedCountdown.backgroundBrightness = brightness
        }
        .onChange(of: backgroundContrast) { _, contrast in
            editedCountdown.backgroundContrast = contrast
        }
    }
    
    @ViewBuilder
    private var editorContent: some View {
        switch section {
        case .countdown:
            OccasionEditor(
                name: $name,
                displayName: $displayName,
                occasion: $occasion,
                type: $type
            )
            .scrollContentBackground(.hidden)
        case .background:
            ScrollView {
                BackgroundEditor(
                    background: editedCountdown.currentBackground,
                    backgroundTransforms: editedCountdown.backgroundTransforms,
                    backgroundColor: $backgroundColor,
                    backgroundFade: $backgroundFade,
                    backgroundBlur: $backgroundBlur,
                    backgroundSaturation: $backgroundSaturation,
                    backgroundBrightness: $backgroundBrightness,
                    backgroundContrast: $backgroundContrast
                ) { data, transforms, resetStates in
                    setBackground(data, transforms: transforms, resetStates: resetStates)
                }
            }
            .safeAreaPadding()
        case .text:
            ScrollView {
                TextStyleEditor(
                    textStyle: $textStyle,
                    textWeight: $textWeight,
                    textColor: $textColor,
                    textOpacity: $textOpacity,
                    textShadow: $textShadow,
                    titleSize: $titleSize,
                    numberSize: $numberSize
                )
            }
            .safeAreaPadding()
        }
    }
    
    private var sectionPicker: some View {
        HStack {
            Picker("", selection: $section) {
                ForEach(CardEditorSection.allCases, id: \.self) { section in
                    Text(section.rawValue.capitalized).tag(section)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var header: some View {
        HStack {
            Button {
                if !editedCountdown.compareTo(countdown: countdown) {
                    cancelAlert = true
                } else {
                    dismiss()
                }
            } label: {
                Text("Cancel")
                    .fontWeight(.semibold)
            }
            .confirmationDialog("Cancel", isPresented: $cancelAlert) {
                Button(false ? "Delete Countdown" : "Discard Changes", role: .destructive) {
                    dismiss()
                }
                Button(false ? "Save Countdown" : "Save Changes") {
                    saveCountdown()
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
            Spacer()
            Button {
                saveCountdown()
                dismiss()
            } label: {
                Text("Save")
                    .fontWeight(.semibold)
            }
        }
    }
    
    private func setBackground(_ data: Data?, transforms: Card.BackgroundTransforms?, resetStates: Bool) {
        editedCountdown.setBackground(data, transforms: transforms)
        UIImpactFeedbackGenerator().impactOccurred()
        Task {
            await editedCountdown.loadCard()
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
    
    private func saveCountdown() {
        countdown.match(editedCountdown)
        clock.save(countdown)
        Task {
            await countdown.loadCards()
        }
    }
    
    private func dismiss() {
        withAnimation {
            isEditing = false
        }
    }
}
