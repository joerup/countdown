//
//  CountdownEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/21/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownEditor: View {
    
    @Environment(\.modelContext) var modelContext
    
    var countdown: Countdown
    
    @Binding var editing: Bool
    
    var onDelete: () -> Void
    
    @State private var tintColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Font.Weight = .regular
    
    @State private var editDestination = false
    @State private var deleteCountdown = false
    
    @State private var editBackground = false
    @State private var editText = false
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    
    private let scale: Double = 0.75
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Button("", systemImage: "calendar") {
                        withAnimation {
                            editDestination.toggle()
                        }
                    }
                    Button("", systemImage: "trash") {
                        withAnimation {
                            deleteCountdown.toggle()
                        }
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            editing = false
                        }
                    } label: {
                        Text("Done")
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                
                CountdownCard(countdown: countdown, scale: scale)
                    .clipShape(RoundedRectangle(cornerRadius: 30*scale))
                    .shadow(radius: 10)
                    .frame(width: geometry.totalSize.width*scale, height: geometry.totalSize.height*scale)
                    .padding(.horizontal, geometry.totalSize.width*0.125)
                    .padding(.vertical)
                
                HStack {
                    iconButton("photo") {
                        editBackground.toggle()
                    }
                    iconButton("textformat") {
                        editText.toggle()
                    }
                }
                .frame(maxHeight: geometry.size.height*0.1)
                .padding(.horizontal)
                
                Spacer(minLength: 0)
            }
        }
        .sheet(isPresented: $editDestination) {
            OccasionEditor(countdown: countdown)
        }
        .popover(isPresented: $editText) {
            textEditor
        }
        .alert("Delete Countdown", isPresented: $deleteCountdown) {
            Button("Cancel", role: .cancel) {
                deleteCountdown = false
            }
            Button("Delete", role: .destructive) {
                modelContext.delete(countdown)
                withAnimation {
                    onDelete()
                    editing = false
                }
            }
        } message: {
            Text("Are you sure you want to delete this countdown? This action cannot be undone.")
        }
        .confirmationDialog("Change background", isPresented: $editBackground) {
            Button("Photo Library") { showPhotoLibrary.toggle() }
            Button("Unsplash") { showUnsplashLibrary.toggle() }
        } message: {
            Text("Choose a new background")
        }
        .photoMenu(isPresented: $showPhotoLibrary) { photo in
            countdown.card?.setBackground(.photo(photo))
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) { photo in
            countdown.card?.setBackground(.photo(photo))
        }
        .onAppear {
            tintColor = countdown.card?.tintColor ?? .white
            textStyle = countdown.card?.textStyle ?? .standard
        }
        .onChange(of: tintColor) { _, color in
            countdown.card?.setTintColor(color)
        }
        .onChange(of: textStyle) { _, style in
            countdown.card?.textStyle = style
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
            .background(Color.gray.opacity(0.2).clipShape(Circle()))
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

