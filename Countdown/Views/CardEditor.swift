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
    
    @State private var backgroundColor: Color = .defaultColor
    @State private var backgroundFade: Double = 1.0
    
    @State private var editBackground = false
    @State private var editFill = false
    @State private var editText = false
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    
    var body: some View {
        HStack {
            iconButton("photo") {
                editBackground.toggle()
            }
            .confirmationDialog("Change background", isPresented: $editBackground) {
                Button("Photo Library") { showPhotoLibrary.toggle() }
                Button("Unsplash") { showUnsplashLibrary.toggle() }
                Button("None") {
                    setBackground(nil)
                }
            } message: {
                Text("Choose a new background")
            }
            
            iconButton("paintbrush") {
                editFill.toggle()
            }
            .popover(isPresented: $editFill, arrowEdge: .bottom) {
                if horizontalSizeClass == .compact {
                    fillEditor
                } else {
                    fillEditor.frame(minWidth: 492, minHeight: 185)
                }
            }
            
            iconButton("textformat") {
                editText.toggle()
            }
            .popover(isPresented: $editText, arrowEdge: .bottom) {
                if horizontalSizeClass == .compact {
                    textEditor
                } else {
                    textEditor.frame(minWidth: 492, minHeight: 185)
                }
            }
        }
        .padding(.horizontal)
        .tint(card.tintColor)
        .photoMenu(isPresented: $showPhotoLibrary) {
            card.loadingBackground()
        } onReturn: { photo in
            setBackground(.photo(photo))
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) {
            card.loadingBackground()
        } onReturn: { photo in
            setBackground(.photo(photo))
        }
        .onAppear {
            tintColor = card.tintColor
            textStyle = card.textStyle
            backgroundColor = card.backgroundColor
            backgroundFade = card.backgroundFade
        }
        .onChange(of: tintColor) { _, color in
            card.tintColor = color
            saveCard()
        }
        .onChange(of: textStyle) { _, style in
            card.textStyle = style
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
    }
    
    private func setBackground(_ data: Card.BackgroundData?) {
        card.setBackground(data)
        UIImpactFeedbackGenerator().impactOccurred()
        saveCard(reload: true)
        if data != nil {
            if backgroundFade == 1.0 {
                backgroundFade = 0
            }
            if backgroundColor == .defaultColor {
                backgroundColor = .white
            }
        } else {
            if backgroundFade == 0 {
                backgroundFade = 1.0
            }
            if backgroundColor == .white {
                backgroundColor = .defaultColor
            }
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
    
    private var fillEditor: some View {
        ScrollView {
            VStack {
                HStack {
                    Slider(value: $backgroundFade, in: 0...1).padding()
                    ColorPicker("", selection: $backgroundColor, supportsOpacity: false).labelsHidden()
                }
                .padding(.horizontal)
                .tint(.pink)
            }
        }
        .presentationDetents([.height(200)])
        .presentationCornerRadius(20)
    }
    
    private var textEditor: some View {
        ScrollView {
            VStack {
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Card.TextStyle.allCases, id: \.self) { style in
                            Button {
                                textStyle = style
                            } label: {
                                Text("123")
                                    .font(.title)
                                    .fontDesign(style.design)
                                    .fontWeight(style.weight)
                                    .fontWidth(style.width)
                                    .foregroundStyle(textStyle == style ? .pink : .black)
                                    .lineLimit(0).minimumScaleFactor(0.5)
                                    .frame(width: 70, height: 70)
                                    .background(.fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.bottom)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0..<5) { i in
                            let color = Color.init(white: Double(i)/4)
                            Button {
                                tintColor = color
                            } label: {
                                colorCircle(color)
                            }
                        }
                        ForEach(0..<12) { i in
                            let color = Color(hue: Double(i)/12, saturation: 0.3, brightness: 1.0)
                            Button {
                                tintColor = color
                            } label: {
                                colorCircle(color)
                            }
                        }
                        colorCircle(AngularGradient(colors: [.red,.orange,.yellow,.green,.mint,.teal,.cyan,.blue,.purple,.pink], center: .center))
                            .overlay(ColorPicker("", selection: $tintColor, supportsOpacity: false).labelsHidden())
                    }
                }
                .scrollIndicators(.hidden)
            }
            .safeAreaPadding()
        }
        .presentationDetents([.height(200)])
        .presentationCornerRadius(20)
    }
    
    private func iconButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            circle(icon)
        }
    }
    
    private func circle(_ icon: String) -> some View {
        ZStack {
            Image(systemName: icon).foregroundStyle(.tint)
        }
        .imageScale(.large)
        .fontWeight(.semibold)
        .frame(width: 50, height: 50)
        .background(Circle().fill(.white).opacity(0.3))
    }
    
    private func colorCircle(_ color: some ShapeStyle) -> some View {
        Circle()
            .fill(color)
            .frame(width: 50, height: 50)
            .overlay {
                Circle()
                    .stroke(.fill, lineWidth: 5)
            }
            .frame(width: 55, height: 55)
    }
}
