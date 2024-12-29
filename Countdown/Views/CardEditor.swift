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
    
    @State private var editBackground = false
    @State private var editText = false
    @State private var editLayout = false
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    @State private var showRepositionMenu = false
    
    private var background: Card.Background? {
        card.countdown?.currentBackground
    }
    
    var body: some View {
        HStack {
            iconButton("photo") {
                editBackground.toggle()
            }
            .popover(isPresented: $editBackground) {
                editorMenu(title: "Background") {
                    backgroundEditor
                }
            }
            iconButton("textformat") {
                editText.toggle()
            }
            .popover(isPresented: $editText) {
                editorMenu(title: "Text Style") {
                    textEditor
                }
            }
            iconButton("align.horizontal.left") {
                editLayout.toggle()
            }
            .popover(isPresented: $editLayout) {
                editorMenu(title: "Layout") {
                    layoutEditor
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
    }
    
    private var backgroundEditor: some View {
        VStack {
            Menu {
                Section {
                    Button("Photo Library") {
                        showPhotoLibrary.toggle()
                    }
                    Button("Unsplash") {
                        showUnsplashLibrary.toggle()
                    }
                    if background?.image != nil {
                        Button("Remove Photo") {
                            setBackground(nil)
                        }
                    }
                }
                if background?.image != nil {
                    Button("Reposition", systemImage: "crop") {
                        showRepositionMenu.toggle()
                    }
                }
            } label: {
                BackgroundDisplay(background: background)
                    .aspectRatio(1.0, contentMode: .fill)
                    .frame(maxWidth: 100, maxHeight: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                    .padding([.horizontal, .bottom])
            }
            
            if background?.allowOverlays ?? false {
                HStack {
                    Slider(value: $backgroundFade, in: 0...1).padding()
                    ColorPicker("", selection: $backgroundColor, supportsOpacity: false).labelsHidden()
                        .frame(minWidth: 50)
                }
                .tint(backgroundColor)
                
                HStack {
                    Slider(value: $backgroundBlur, in: 0...10).padding()
                        .tint(.gray)
                    Image(systemName: "drop")
                        .imageScale(.large)
                        .foregroundStyle(.cyan)
                        .frame(minWidth: 50)
                }
            }
        }
        .photoMenu(isPresented: $showPhotoLibrary) {
            
        } onCancel: {
            
        } onReturn: { background in
            setBackground(background)
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) {
            
        } onCancel: {
            
        } onReturn: { background in
            setBackground(background)
        }
        .repositionMenu(isPresented: $showRepositionMenu, image: background?.image, data: card.backgroundData) {
            
        } onReturn: { background in
            setBackground(background)
        }
    }
    
    private var textEditor: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Card.TextStyle.allCases, id: \.self) { style in
                        Button {
                            textStyle = style
                        } label: {
                            Text("12")
                                .font(.largeTitle)
                                .fontWeight(Font.Weight(rawValue: textWeight))
                                .fontDesign(style.design)
                                .fontWidth(style.width)
                                .foregroundStyle(textStyle == style ? .pink : .black)
                                .lineLimit(0).minimumScaleFactor(0.5)
                                .frame(width: 70, height: 70)
                                .background(Material.ultraThin.opacity(textStyle == style ? 1.0 : 0.25))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom)
            
            HStack {
                Image(systemName: "textformat")
                    .imageScale(.large)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                Slider(
                    value: Binding(
                        get: { Double(textWeight) },
                        set: { textWeight = Int($0) }
                    ),
                    in: Double(Font.Weight.minimum + 1)...Double(Font.Weight.maximum - 1),
                    step: 1
                )
                .tint(.pink)
                Image(systemName: "textformat")
                    .imageScale(.large)
                    .fontWeight(.heavy)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
            }
            
            Divider()
                .padding(.vertical)
            
            CustomColorPicker(color: $tintColor)
        }
    }
    
    private var layoutEditor: some View {
        LayoutEditor(layout: $layout)
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
