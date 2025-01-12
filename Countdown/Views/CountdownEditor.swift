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
    
    @Environment(\.dismiss) private var dismissEditor
    
    private var countdown: Countdown?
    private var create: Bool
    
    private var onSave: (Countdown) -> Void
    
    @State private var section: CardEditorSection = .countdown
    
    private enum CardEditorSection: String, CaseIterable, Hashable {
        case countdown, background, text
    }
    
    @State private var changeToggle: Bool?
    @State private var cancelAlert: Bool = false
    @State private var deleteCountdown = false
    
    @State private var editedCountdown: CountdownInstance
    
    @State private var name: String
    @State private var displayName: String
    @State private var occasion: Occasion
    @State private var type: EventType
    
    @State private var textColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Int = Font.Weight.medium.rawValue
    @State private var textOpacity: Double = 1.0
    @State private var textShadow: Double = 0
    @State private var titleSize: Double = 1.0
    @State private var numberSize: Double = 1.0
    
    @State private var backgroundColor: Color? = .defaultColor
    @State private var backgroundFade: Double = 0
    @State private var backgroundBlur: Double = 0
    @State private var backgroundDim: Double = 0
    @State private var backgroundSaturation: Double = 0
    @State private var backgroundBrightness: Double = 0
    @State private var backgroundContrast: Double = 0
    
    init(name: String, displayName: String, type: EventType, occasion: Occasion, onSave: @escaping (Countdown) -> Void) {
        self._name = State(initialValue: name)
        self._displayName = State(initialValue: displayName)
        self._occasion = State(initialValue: occasion)
        self._type = State(initialValue: type)
        self.create = true
        self.onSave = onSave
        
        let instance = CountdownInstance(name: name, displayName: displayName, type: type, occasion: occasion)
        self._editedCountdown = State(initialValue: instance)
    }
    
    init(countdown: Countdown, onSave: @escaping (Countdown) -> Void) {
        self.countdown = countdown
        self.create = false
        self.onSave = onSave
        
        let instance = CountdownInstance(from: countdown)
        self._editedCountdown = State(initialValue: instance)
        
        _name = State(initialValue: instance.name)
        _displayName = State(initialValue: instance.displayName)
        _occasion = State(initialValue: instance.occasion)
        _type = State(initialValue: instance.type)
        _textColor = State(initialValue: instance.textColor)
        _textStyle = State(initialValue: instance.textStyle)
        _textWeight = State(initialValue: instance.textWeight)
        _textOpacity = State(initialValue: instance.textOpacity)
        _textShadow = State(initialValue: instance.textShadow)
        _titleSize = State(initialValue: instance.titleSize)
        _numberSize = State(initialValue: instance.numberSize)
        _backgroundColor = State(initialValue: instance.backgroundColor)
        _backgroundFade = State(initialValue: instance.backgroundFade)
        _backgroundBlur = State(initialValue: instance.backgroundBlur)
        _backgroundDim = State(initialValue: instance.backgroundDim)
        _backgroundSaturation = State(initialValue: instance.backgroundSaturation)
        _backgroundBrightness = State(initialValue: instance.backgroundBrightness)
        _backgroundContrast = State(initialValue: instance.backgroundContrast)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                header
                    .padding()
                
                CountdownSquare(instance: editedCountdown)
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .frame(height: min(min(geometry.size.width * 0.6, geometry.size.height * 0.3), 300))
                    .padding(.top, -30)
                    .padding(.bottom, 12)
                    .id(changeToggle)
                
                VStack(spacing: 0) {
                    sectionPicker
                        .padding()
                    Divider()
                    editorContent
                }
                .background(Material.ultraThin)
                .transition(.move(edge: .bottom))
            }
            .background {
                BackgroundDisplay(background: editedCountdown.currentBackground?.full, color: backgroundColor, fade: backgroundFade, blur: backgroundBlur, dim: backgroundDim, brightness: backgroundBrightness, saturation: backgroundSaturation, contrast: backgroundContrast)
                    .overlay(Material.ultraThin)
            }
            .onChange(of: name) { _, name in
                editedCountdown.name = name
                makeChange()
            }
            .onChange(of: displayName) { _, name in
                editedCountdown.displayName = name
                makeChange()
            }
            .onChange(of: occasion) { _, occasion in
                editedCountdown.occasion = occasion
                makeChange()
            }
            .onChange(of: type) { _, type in
                editedCountdown.type = type
                makeChange()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .interactiveDismissDisabled()
        .onChange(of: textColor) { _, color in
            editedCountdown.textColor = color
            makeChange()
        }
        .onChange(of: textStyle) { _, style in
            editedCountdown.textStyle = style
            makeChange()
        }
        .onChange(of: textWeight) { _, weight in
            editedCountdown.textWeight = weight
            makeChange()
        }
        .onChange(of: textOpacity) { _, opacity in
            editedCountdown.textOpacity = opacity
            makeChange()
        }
        .onChange(of: textShadow) { _, shadow in
            editedCountdown.textShadow = shadow
            makeChange()
        }
        .onChange(of: titleSize) { _, size in
            editedCountdown.titleSize = size
            makeChange()
        }
        .onChange(of: numberSize) { _, size in
            editedCountdown.numberSize = size
            makeChange()
        }
        .onChange(of: backgroundColor) { _, color in
            editedCountdown.backgroundColor = color
            makeChange()
        }
        .onChange(of: backgroundFade) { _, fade in
            editedCountdown.backgroundFade = fade
            makeChange()
        }
        .onChange(of: backgroundBlur) { _, blur in
            editedCountdown.backgroundBlur = blur
            makeChange()
        }
        .onChange(of: backgroundDim) { _, dim in
            editedCountdown.backgroundDim = dim
            makeChange()
        }
        .onChange(of: backgroundSaturation) { _, saturation in
            editedCountdown.backgroundSaturation = saturation
            makeChange()
        }
        .onChange(of: backgroundBrightness) { _, brightness in
            editedCountdown.backgroundBrightness = brightness
            makeChange()
        }
        .onChange(of: backgroundContrast) { _, contrast in
            editedCountdown.backgroundContrast = contrast
            makeChange()
        }
    }
    
    @ViewBuilder
    private var editorContent: some View {
        switch section {
        case .countdown:
            List {
                Group {
                    OccasionEditor(
                        name: $name,
                        displayName: $displayName,
                        occasion: $occasion,
                        type: $type
                    )
                    if !create {
                        deleteButton
                    }
                }
                .listRowBackground(Color.white.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        case .background:
            ScrollView {
                BackgroundEditor(
                    background: editedCountdown.currentBackground,
                    backgroundTransforms: editedCountdown.backgroundTransforms,
                    backgroundColor: $backgroundColor,
                    backgroundFade: $backgroundFade,
                    backgroundBlur: $backgroundBlur,
                    backgroundDim: $backgroundDim,
                    backgroundSaturation: $backgroundSaturation,
                    backgroundBrightness: $backgroundBrightness,
                    backgroundContrast: $backgroundContrast
                ) { data, transforms, resetStates in
                    setBackground(data, transforms: transforms, resetStates: resetStates)
                    makeChange()
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
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            deleteCountdown.toggle()
        } label: {
            HStack {
                Text("Delete Countdown")
                Spacer()
                Image(systemName: "trash")
            }
        }
        .alert("Delete \(displayName)", isPresented: $deleteCountdown) {
            Button("Cancel", role: .cancel) {
                deleteCountdown = false
            }
            Button("Delete", role: .destructive) {
                if let countdown {
                    clock.delete(countdown)
                    dismiss(deselect: true)
                }
            }
        } message: {
            Text("Are you sure you want to delete this countdown? This action cannot be undone.")
        }
    }
    
    private var header: some View {
        HStack {
            Button {
                if changeToggle != nil {
                    cancelAlert = true
                } else {
                    dismiss()
                }
            } label: {
                Text("Cancel")
                    .foregroundStyle(.white)
            }
            .confirmationDialog("Cancel", isPresented: $cancelAlert) {
                Button(create ? "Delete Countdown" : "Discard Changes", role: .destructive) {
                    dismiss()
                }
                Button(create ? "Save Countdown" : "Save Changes") {
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
                Text(create ? "Add" : "Save")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
        }
    }
    
    private func setBackground(_ data: Data?, transforms: Card.BackgroundTransforms?, resetStates: Bool) {
        editedCountdown.setBackground(data, transforms: transforms)
        UIImpactFeedbackGenerator().impactOccurred()
        Task {
            await editedCountdown.loadCard()
            if resetStates {
                backgroundColor = data == nil ? .defaultColor : nil
                backgroundFade = 0.4
                backgroundBlur = 0
                backgroundDim = 0
                backgroundBrightness = 0
                backgroundSaturation = 1.0
                backgroundContrast = 1.0
            }
        }
    }
    
    private func makeChange() {
        if changeToggle != nil {
            changeToggle?.toggle()
        } else {
            changeToggle = true
        }
    }
    
    private func saveCountdown() {
        if let countdown {
            countdown.match(editedCountdown)
            clock.save(countdown)
            Task {
                await countdown.loadCards()
            }
            onSave(countdown)
        } else {
            let countdown = Countdown(from: editedCountdown)
            clock.add(countdown)
            Task {
                await countdown.loadCards()
            }
            onSave(countdown)
        }
    }
    
    private func dismiss(deselect: Bool = false) {
        withAnimation {
            dismissEditor()
            if deselect {
                clock.select(nil)
            }
        }
    }
}
