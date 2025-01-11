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
    var backgroundTransforms: Card.BackgroundTransforms?
    
    @Binding var backgroundColor: Color?
    @Binding var backgroundFade: Double
    @Binding var backgroundBlur: Double
    @Binding var backgroundDim: Double
    @Binding var backgroundSaturation: Double
    @Binding var backgroundBrightness: Double
    @Binding var backgroundContrast: Double
    
    var setBackground: (Data?, Card.BackgroundTransforms?, Bool) -> Void
    
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
                        if background != nil {
                            Button("Remove Photo") {
                                setBackground(nil, nil, true)
                            }
                        }
                    }
                    if background != nil {
                        Button("Reposition", systemImage: "crop") {
                            showRepositionMenu.toggle()
                        }
                    }
                } label: {
                    BackgroundDisplay(background: background?.square, color: backgroundColor, fade: backgroundFade, blur: backgroundBlur, dim: backgroundDim, brightness: backgroundBrightness, saturation: backgroundSaturation, contrast: backgroundContrast)
                        .aspectRatio(1.0, contentMode: .fill)
                        .frame(maxWidth: 140, maxHeight: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay {
                            Image(systemName: "photo")
                                .font(.title)
                                .foregroundStyle(.gray)
                        }
                }
            }
            
            Divider()
                .padding(.vertical)
            
            if background != nil {
                HStack {
                    CustomSlider(value: $backgroundDim, in: 0...0.8, opacityGrid: true, colors: [.clear, .black.opacity(0.8)])
                    Image(systemName: "sun.horizon")
                        .frame(minWidth: 25)
                }
                .padding(.bottom, 8)
                HStack {
                    CustomSlider(value: $backgroundBlur, in: 0...10, mask: true, colors: [.white, .cyan])
                    Image(systemName: "drop")
                        .frame(minWidth: 25)
                }
                
                Divider()
                    .padding(.vertical)
                
                HStack {
                    CustomSlider(value: $backgroundBrightness, in: -0.4...0.4, colors: [.black, .white])
                    Image(systemName: "sun.min")
                        .frame(minWidth: 25)
                }
                .padding(.bottom, 8)
                HStack {
                    CustomSlider(value: $backgroundSaturation, in: 0...2, colors: [.gray, .pink])
                    Image(systemName: "circle.fill")
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], startPoint: .leading, endPoint: .trailing)
                                .mask(Image(systemName: "circle.fill"))
                        )
                        .frame(minWidth: 25)
                }
                .padding(.bottom, 8)
                HStack {
                    CustomSlider(value: $backgroundContrast, in: 0.1...1.9, mask: true, colors: [.white, .black])
                    Image(systemName: "circle.lefthalf.filled")
                        .frame(minWidth: 25)
                }
                
                Divider()
                    .padding(.top)
                    
                CustomColorPicker(color: $backgroundColor, opacity: $backgroundFade, shape: RoundedRectangle(cornerRadius: 15), sliderValue: .brightness, allowNoColor: true, allowWhite: false, opacityRange: 0...0.8)
                    .padding(.vertical)
            }
        }
        .photoMenu(isPresented: $showPhotoLibrary) { background, transform in
            setBackground(background, .init(square: transform), true)
        }
        .unsplashMenu(isPresented: $showUnsplashLibrary) { background, transform in
            setBackground(background, .init(square: transform), true)
        }
        .repositionMenu(isPresented: $showRepositionMenu, image: background?.full, transform: backgroundTransforms?.square) { transform in
            setBackground(background?.data, .init(square: transform), false)
        }
    }
}
