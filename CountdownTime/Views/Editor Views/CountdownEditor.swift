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
    
    @State private var editDestination = false
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    @State private var showGradientEditor = false
    
    @State private var editText: Bool = false
    
    var namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                HStack {
                    Button("Cancel") {
                        withAnimation {
                            editing = false
                        }
                    }
                    Spacer()
                    Button("Done") {
                        withAnimation {
                            editing = false
                        }
                    }
                }
                .padding(.horizontal)
                
                CountdownView(countdown: countdown, editing: $editing)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 10)
                    .matchedGeometryEffect(id: countdown, in: namespace)
                    .frame(width: geometry.totalSize.width*0.75, height: geometry.totalSize.height*0.75)
                    .padding(.horizontal, geometry.totalSize.width*0.125)
                    .padding(.vertical)
                
                Spacer(minLength: 0)
                
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
                        Button {
                            showGradientEditor.toggle()
                        } label: {
                            Label("Gradient", systemImage: "paintpalette")
                        }
                    }
                    iconButton("paintpalette") {
                        
                    }
                    iconButton("textformat") {
                        self.editText.toggle()
                    }
                    Spacer()
                    iconButton("calendar") {
                        self.editDestination.toggle()
                    }
                    iconButton("trash") {
                        
                    }
                }
                .frame(maxHeight: geometry.size.height*0.1)
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $editDestination) {
            DestinationEditor(countdown: countdown)
        }
        .sheet(isPresented: $editText) {
            textEditor
        }
        .photoMenu(isPresented: $showPhotoLibrary) { photo in
            countdown.card.setBackground(.photo(photo))
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) { photo in
            countdown.card.setBackground(.photo(photo))
        }
        .gradientMenu(isPresented: $showGradientEditor) { colors in
            countdown.card.setBackground(.gradient(colors))
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
    
    private var textEditor: some View {
        sheetDisplay(title: "Text") {
            VStack(alignment: .leading) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(Countdown.TextDesign.allCases) { design in
                        Button {
                            
                        } label: {
                            VStack(spacing: 0) {
                                Spacer(minLength: 0)
                                CounterDisplay(countdown: countdown, textDesign: design, type: .full, size: 25)
                                TitleDisplay(countdown: countdown, textDesign: design, size: 15)
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1.0, contentMode: .fit)
                            .background(Color.pink.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                }
            }
        }
    }
    
    private func sheetDisplay<Content: View>(title: String, content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(.title, design: .rounded, weight: .semibold))
                content()
                    .frame(maxWidth: .infinity)
            }
            .safeAreaPadding()
        }
        .presentationDetents([.fraction(0.35), .fraction(0.8)])
    }
}

