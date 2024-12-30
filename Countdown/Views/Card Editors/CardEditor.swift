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
    
    @State private var tintColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Int = Font.Weight.medium.rawValue
    @State private var textShadow: Double = 0
    
    @State private var backgroundColor: Color = .white
    @State private var backgroundFade: Double = 0
    @State private var backgroundBlur: Double = 0
    
    @State private var layout: Card.Layout = .basic
    
    @State private var editLayout = false
    @State private var editBackground = false
    @State private var editTextStyle = false
    
    private var background: Card.Background? {
        card.countdown?.currentBackground
    }
    
    var body: some View {
        HStack {
            iconButton("align.horizontal.left") {
                editLayout.toggle()
            }
            .popover(isPresented: $editLayout) {
                editorMenu(title: "Layout") {
                    LayoutEditor(layout: $layout)
                }
            }
            iconButton("photo") {
                editBackground.toggle()
            }
            .popover(isPresented: $editBackground) {
                editorMenu(title: "Background") {
                    BackgroundEditor(background: background, backgroundData: card.backgroundData, backgroundColor: $backgroundColor, backgroundFade: $backgroundFade, backgroundBlur: $backgroundBlur, setBackground: setBackground(_:))
                }
            }
            iconButton("textformat") {
                editTextStyle.toggle()
            }
            .popover(isPresented: $editTextStyle) {
                editorMenu(title: "Text Style") {
                    TextStyleEditor(textStyle: $textStyle, textWeight: $textWeight, tintColor: $tintColor)
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            tintColor = card.tintColor
            textStyle = card.textStyle
            textWeight = card.textWeight
            textShadow = card.textShadow
            backgroundColor = card.backgroundColor
            backgroundFade = card.backgroundFade
            backgroundBlur = card.backgroundBlur
            layout = card.layout ?? .basic
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
        .onChange(of: layout) { _, layout in
            card.layout = layout
            saveCard()
        }
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
    
    private func editorMenu<Content: View>(title: String, content: @escaping () -> Content) -> some View {
        Group {
            if horizontalSizeClass == .compact {
                EditorMenu(title: title, content: content)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(20)
            } else {
                EditorMenu(title: title, content: content)
                    .frame(minWidth: 492, minHeight: 185)
            }
        }
        .presentationBackground(Material.ultraThin)
        .environment(\.colorScheme, .light)
    }
    
    private func iconButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            circle(icon)
        }
        .tint(card.tintColor)
    }
    
    private func circle(_ icon: String) -> some View {
        ZStack {
            Image(systemName: icon)
                .foregroundStyle(.white)
            Image(systemName: icon)
                .foregroundStyle(.tint.opacity(0.5))
        }
        .imageScale(.large)
        .fontWeight(.semibold)
        .frame(width: 50, height: 50)
        .background(Circle().fill(Material.ultraThin.opacity(0.5)))
    }
}
