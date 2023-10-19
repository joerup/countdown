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
    
    @EnvironmentObject private var clock: Clock
    
    var countdown: Countdown
    
    @Binding var editing: Bool
    
    var onDelete: () -> Void
    
    @State private var editDestination = false
    @State private var deleteCountdown = false
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    @State private var showGradientEditor = false
    
    @State private var editTint = false
    @State private var editFont = false
    
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
                
                CountdownCard(countdown: countdown, editing: true)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 10)
                    .frame(width: geometry.totalSize.width*0.75, height: geometry.totalSize.height*0.75)
                    .padding(.horizontal, geometry.totalSize.width*0.125)
                    .padding(.vertical)
                
                HStack {
                    iconMenu("photo") {
                        Button {
                            showPhotoLibrary.toggle()
                        } label: {
                            Label("Photo Library", systemImage: "photo")
                        }
                        Button {
                            showUnsplashLibrary.toggle()
                        } label: {
                            Label("Search Photos", systemImage: "magnifyingglass")
                        }
                    }
                    iconButton("paintpalette") {
                        editTint.toggle()
                    }
                    iconButton("textformat") {
                        editFont.toggle()
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
        .sheet(isPresented: $editTint) {
            tintEditor
        }
        .sheet(isPresented: $editFont) {
            fontEditor
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
        .photoMenu(isPresented: $showPhotoLibrary) { photo in
            countdown.card?.setBackground(.photo(photo))
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) { photo in
            countdown.card?.setBackground(.photo(photo))
        }
    }
    
    private func iconButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            circle(icon)
        }
    }
    private func iconMenu<Content: View>(_ icon: String, @ViewBuilder menu: () -> Content) -> some View {
        Menu(content: menu) {
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
    
    private var tintEditor: some View {
        sheetDisplay {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Color.standardColors, id: \.self) { color in
                        Button {
                            countdown.card?.tint = color
                        } label: {
                            ZStack {
                                Circle().fill(color)
                                Circle().fill(.regularMaterial)
                            }
                            .frame(height: 50)
                        }
                    }
                }
                .environment(\.colorScheme, .light)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    private var fontEditor: some View {
        sheetDisplay {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Card.TextStyle.allCases) { textStyle in
                        Button {
                            countdown.card?.textStyle = textStyle
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.init(white: 0.9))
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .frame(maxHeight: 50)
                                Text("\(clock.daysRemaining(for: countdown))")
                                    .font(.system(size: 30))
                                    .fontDesign(textStyle.design)
                                    .fontWeight(textStyle.weight)
                                    .fontWidth(textStyle.width)
                            }
                            .frame(height: 50)
                        }
                    }
                }
            }
        }
    }
    
    private func sheetDisplay<Content: View>(content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                content()
                    .frame(maxWidth: .infinity)
            }
            .safeAreaPadding()
        }
        .presentationDetents([.fraction(0.1)])
    }
}

