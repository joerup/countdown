//
//  CustomColorPicker.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/28/24.
//

import SwiftUI

struct CustomColorPicker<ColorShape: Shape>: View {
    
    @Binding var color: Color
    var shape: ColorShape
    var sliderValue: SliderValue?
    
    enum SliderValue {
        case saturation, brightness
    }
    
    @State private var isWhite: Bool = false
    @State private var isCustom: Bool = false
    
    @State private var saturation: Double
    @State private var brightness: Double
    
    private let hueCount: Int = 12
    
    @State private var scrollPosition: Int?
    
    init(color: Binding<Color>, shape: ColorShape, sliderValue: SliderValue? = nil) {
        self._color = color
        self.shape = shape
        self.sliderValue = sliderValue
        
        switch sliderValue {
        case .saturation:
            saturation = 0.3
            brightness = 1.0
        case .brightness:
            saturation = 1.0
            brightness = 0.8
        case nil:
            saturation = 0.3
            brightness = 1.0
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal) {
                HStack {
                    Button {
                        color = .white
                    } label: {
                        colorIcon(.white, isSelected: isWhite)
                    }
                    .id(0)
                    ForEach(0..<hueCount, id: \.self) { i in
                        let hue = Double(i)/Double(hueCount)
                        let color = Color(hue: hue, saturation: saturation, brightness: brightness)
                        Button {
                            self.color = color
                        } label: {
                            colorIcon(color, isSelected: !isWhite && !isCustom && self.color.hue.isApproximately(hue))
                        }
                        .id(i + 1)
                    }
                    colorIcon(AngularGradient(colors: [.teal,.cyan,.blue,.purple,.pink,.red,.orange,.yellow,.green,.mint], center: .center), isSelected: isCustom)
                        .overlay(ColorPicker("", selection: $color, supportsOpacity: false).labelsHidden().scaleEffect(2.0).opacity(isCustom ? 1 : 0.1))
                        .id(hueCount + 1)
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            
            if !isWhite && !isCustom {
                switch sliderValue {
                case .saturation:
                    CustomSlider(value: $saturation, in: 0.1...0.5, colors: [Color(hue: color.hue, saturation: 0.1, brightness: color.value), Color(hue: color.hue, saturation: 0.5, brightness: color.value)])
                        .tint(color)
                        .padding(.horizontal)
                        .onChange(of: saturation) { _, saturation in
                            color = Color(hue: color.hue, saturation: saturation, brightness: color.value)
                        }
                case .brightness:
                    CustomSlider(value: $brightness, in: 0.25...1.0, colors: [Color(hue: color.hue, saturation: color.saturation, brightness: 0.25), Color(hue: color.hue, saturation: color.saturation, brightness: 1.0)])
                        .tint(color)
                        .padding(.horizontal)
                        .onChange(of: brightness) { _, saturation in
                            color = Color(hue: color.hue, saturation: color.saturation, brightness: brightness)
                        }
                default:
                    EmptyView()
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
            switch sliderValue {
            case .saturation:
                saturation = color.saturation
            case .brightness:
                brightness = color.value
            default:
                break
            }
        }
    }
    
    private func colorIcon(_ color: some ShapeStyle, isSelected: Bool) -> some View {
        shape
            .fill(color)
            .frame(width: 50, height: 50)
            .overlay {
                shape.stroke(isSelected ? .white : .gray, lineWidth: 5)
            }
            .frame(width: 55, height: 55)
    }
}
