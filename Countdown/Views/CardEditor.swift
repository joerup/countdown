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
    
    @EnvironmentObject var clock: Clock
    
    var card: Card
    
    @State private var tintColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Font.Weight = .regular
    
    @State private var editBackground = false
    @State private var editText = false
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    
    var body: some View {
        HStack {
            iconButton("photo") {
                editBackground.toggle()
            }
            iconButton("textformat") {
                editText.toggle()
            }
        }
        .padding(.horizontal)
        .tint(card.tintColor)
        .popover(isPresented: $editText) {
            textEditor
        }
        .confirmationDialog("Change background", isPresented: $editBackground) {
            Button("Photo Library") { showPhotoLibrary.toggle() }
            Button("Unsplash") { showUnsplashLibrary.toggle() }
        } message: {
            Text("Choose a new background")
        }
        .photoMenu(isPresented: $showPhotoLibrary) { photo in
            card.setBackground(.photo(photo))
            UIImpactFeedbackGenerator().impactOccurred()
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) { link in
            card.setBackground(.photoLink(link))
            UIImpactFeedbackGenerator().impactOccurred()
        }
        .onAppear {
            tintColor = card.tintColor
            textStyle = card.textStyle
        }
        .onChange(of: tintColor) { _, color in
            card.setTintColor(color)
        }
        .onChange(of: textStyle) { _, style in
            card.textStyle = style
        }
    }
    
    private var textEditor: some View {
        NavigationStack {
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
                    .padding(.vertical)
                    
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
                                .frame(width: 50, height: 50)
                                .overlay(ColorPicker("", selection: $tintColor, supportsOpacity: false).labelsHidden().opacity(0.015))
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .safeAreaPadding()
            }
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
        Image(systemName: icon)
            .symbolRenderingMode(.multicolor)
            .imageScale(.large)
            .fontWeight(.semibold)
            .padding()
            .aspectRatio(1.0, contentMode: .fit)
            .background(Color.gray.clipShape(Circle()))
            .shadow(radius: 5)
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
