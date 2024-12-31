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
    @Binding var backgroundSaturation: Double
    @Binding var backgroundBrightness: Double
    @Binding var backgroundContrast: Double
    
    var setBackground: (Card.BackgroundData?) -> Void
    
    var body: some View {
        VStack {
            HStack {
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
                    BackgroundDisplay(background: background, blur: backgroundBlur, brightness: backgroundBrightness, saturation: backgroundSaturation, contrast: backgroundContrast)
                        .aspectRatio(1.0, contentMode: .fill)
                        .frame(maxWidth: 140, maxHeight: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay {
                            Image(systemName: "photo")
                                .font(.title)
                                .foregroundStyle(.gray)
                        }
                }
                
                if background?.allowOverlays ?? false {
                    VStack(spacing: -25) {
                        HStack(spacing: 0) {
                            Slider(value: $backgroundBrightness, in: -0.5...0.5)
                                .padding()
                            Image(systemName: "sun.max")
                                .foregroundStyle(.yellow)
                                .frame(minWidth: 20)
                        }
                        HStack(spacing: 0) {
                            Slider(value: $backgroundSaturation, in: 0...2)
                                .padding()
                            Image(systemName: "paintpalette")
                                .renderingMode(.original)
                                .frame(minWidth: 20)
                        }
                        HStack(spacing: 0) {
                            Slider(value: $backgroundContrast, in: 0.1...1.9)
                                .padding()
                            Image(systemName: "circle.lefthalf.filled")
                                .foregroundStyle(.black)
                                .frame(minWidth: 20)
                        }
                        HStack(spacing: 0) {
                            Slider(value: $backgroundBlur, in: 0...10)
                                .padding()
                            Image(systemName: "drop.fill")
                                .foregroundStyle(.blue)
                                .frame(minWidth: 20)
                        }
                    }
                    .padding(.leading, 8)
                }
            }
            
            Divider()
                .padding(.vertical)
            
            if background?.allowOverlays ?? false {
                VStack {
                    CustomColorPicker(color: $backgroundColor, shape: RoundedRectangle(cornerRadius: 10), sliderValue: .brightness)
                    
                    CustomSlider(value: $backgroundFade, in: 0...0.8, colors: [.clear, backgroundColor])
                        .tint(backgroundColor)
                        .padding()
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
