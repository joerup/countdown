//
//  CustomColorPicker.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/28/24.
//

import SwiftUI

struct CustomColorPicker: View {
    
    @Binding var color: Color
    
    @State private var isWhite: Bool = false
    @State private var isCustom: Bool = false
    
    @State private var saturation: Double = 0.3
    
    private let hueCount: Int = 12
    
    @State private var scrollPosition: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal) {
                HStack {
                    Button {
                        color = .white
                    } label: {
                        colorCircle(.white, isSelected: isWhite)
                    }
                    .id(0)
                    ForEach(0..<hueCount, id: \.self) { i in
                        let hue = Double(i)/Double(hueCount)
                        let color = Color(hue: hue, saturation: saturation, brightness: 1.0)
                        Button {
                            self.color = color
                        } label: {
                            colorCircle(color, isSelected: !isWhite && !isCustom && self.color.hue.isApproximately(hue))
                        }
                        .id(i + 1)
                    }
                    colorCircle(AngularGradient(colors: [.teal,.cyan,.blue,.purple,.pink,.red,.orange,.yellow,.green,.mint], center: .center), isSelected: isCustom)
                        .overlay(ColorPicker("", selection: $color, supportsOpacity: false).labelsHidden().scaleEffect(2.0).opacity(isCustom ? 1 : 0.1))
                        .id(hueCount + 1)
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            
            if !isWhite && !isCustom {
                Slider(value: $saturation, in: 0.1...0.5)
                    .tint(color)
                    .padding(.horizontal)
                    .onChange(of: saturation) { _, saturation in
                        color = Color(hue: color.hue, saturation: saturation, brightness: color.value)
                    }
            }
        }
        .onAppear {
            updateState(color: color)
            if isWhite {
                scrollPosition = 0
            } else if isCustom {
                scrollPosition = hueCount + 1
            } else {
                scrollPosition = Int(round(color.hue * Double(hueCount))) + 1
            }
        }
        .onChange(of: color) { _, color in
            updateState(color: color)
        }
    }
    
    private func updateState(color: Color) {
        isWhite = color.hue.isApproximately(Color.white.hue) && color.saturation.isApproximately(Color.white.saturation) && color.value.isApproximately(Color.white.value)
        isCustom = !(color.hue * Double(hueCount)).isApproximately((color.hue * Double(hueCount)).rounded())
        if !isWhite && !isCustom {
            saturation = color.saturation
        }
    }
    
    private func colorCircle(_ color: some ShapeStyle, isSelected: Bool) -> some View {
        Circle()
            .fill(color)
            .frame(width: 50, height: 50)
            .overlay {
                Circle()
                    .stroke(isSelected ? .white : .gray, lineWidth: 5)
            }
            .frame(width: 55, height: 55)
    }
}
