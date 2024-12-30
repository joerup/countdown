//
//  BackgroundEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/29/24.
//

import SwiftUI
import CountdownUI
import CountdownData

struct BackgroundEditor: View {
    
    @State private var showPhotoLibrary = false
    @State private var showUnsplashLibrary = false
    @State private var showRepositionMenu = false
    
    var background: Card.Background?
    var backgroundData: Card.BackgroundData?
    
    @Binding var backgroundColor: Color
    @Binding var backgroundFade: Double
    @Binding var backgroundBlur: Double
    
    var setBackground: (Card.BackgroundData?) -> Void
    
    var body: some View {
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
        .photoMenu(isPresented: $showPhotoLibrary) { background in
            setBackground(background)
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) { background in
            setBackground(background)
        }
        .repositionMenu(isPresented: $showRepositionMenu, image: background?.image, data: backgroundData) { background in
            setBackground(background)
        }
    }
}
