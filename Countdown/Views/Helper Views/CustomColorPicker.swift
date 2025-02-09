//
//  CustomColorPicker.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/28/24.
//

import SwiftUI

struct CustomColorPicker<ColorShape: Shape>: View {
    
    @Binding var color: Color?
    @Binding var opacity: Double
    var shape: ColorShape
    
    @State private var isWhite: Bool = false
    @State private var isCustom: Bool = false
    
    @State private var saturation: Double
    @State private var brightness: Double
    
    private let brightnessSlider: Bool
    private let saturationSlider: Bool
    private let opacitySlider: Bool
    private let allowNoColor: Bool
    private let allowWhite: Bool
    private let hueCount: Int
    private let brightnessRange: ClosedRange<Double>
    private let saturationRange: ClosedRange<Double>
    private let opacityRange: ClosedRange<Double>
    
    @State private var scrollPosition: Int?
    
    init(color: Binding<Color?>, opacity: Binding<Double>, shape: ColorShape, brightnessSlider: Bool, saturationSlider: Bool, opacitySlider: Bool, allowNoColor: Bool = false, allowWhite: Bool = true, hueCount: Int = 12, brightnessRange: ClosedRange<Double> = 0...1, saturationRange: ClosedRange<Double> = 0...1, opacityRange: ClosedRange<Double> = 0...1) {
        self._color = color
        self._opacity = opacity
        self.shape = shape
        self.brightnessSlider = brightnessSlider
        self.saturationSlider = saturationSlider
        self.opacitySlider = opacitySlider
        self.allowNoColor = allowNoColor
        self.allowWhite = allowWhite
        self.hueCount = hueCount
        self.brightnessRange = brightnessRange
        self.saturationRange = saturationRange
        self.opacityRange = opacityRange
        
        if brightnessSlider {
            saturation = 0.6
            brightness = 0.625
        }
        else if saturationSlider {
            saturation = 0.3
            brightness = 1.0
        }
        else {
            saturation = 0.3
            brightness = 1.0
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal) {
                HStack {
                    if allowNoColor {
                        Button {
                            self.color = nil
                        } label: {
                            colorIcon(Color.white.opacity(color == nil ? 0.5 : 0.1), isSelected: color == nil)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.gray)
                                        .imageScale(.large)
                                }
                        }
                        .id(0)
                    }
                    if allowWhite {
                        Button {
                            self.color = .white
                        } label: {
                            colorIcon(.white, isSelected: isWhite)
                        }
                        .id(1)
                    }
                    ForEach(0..<hueCount, id: \.self) { i in
                        let hue = Double(i)/Double(hueCount)
                        let color = Color(hue: hue, saturation: saturation, brightness: brightness)
                        Button {
                            self.color = color
                        } label: {
                            colorIcon(color, isSelected: !isWhite && !isCustom && self.color != nil && self.color!.hue.isApproximately(hue))
                        }
                        .id(i + 2)
                    }
                    colorIcon(AngularGradient(colors: [.teal,.cyan,.blue,.purple,.pink,.red,.orange,.yellow,.green,.mint], center: .center), isSelected: isCustom)
                        .overlay(colorIcon(color ?? .white, isSelected: isCustom, bordered: false).scaleEffect(0.7).opacity(isCustom ? 1 : 0))
                        .overlay(ColorPicker("", selection: Binding(get: { color ?? .white }, set: { color = $0 }), supportsOpacity: false).labelsHidden().scaleEffect(2.0).opacity(0.1))
                        .id(hueCount + 2)
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            .padding(.bottom, 4)
            
            if !isWhite && !isCustom, let color {
                
                if brightnessSlider {
                    CustomSlider(value: $brightness, in: brightnessRange, colors: [Color(hue: color.hue, saturation: color.saturation, brightness: brightnessRange.lowerBound), Color(hue: color.hue, saturation: color.saturation, brightness: brightnessRange.upperBound)])
                        .tint(color)
                        .onChange(of: brightness) { _, saturation in
                            self.color = Color(hue: color.hue, saturation: color.saturation, brightness: brightness)
                        }
                }
                
                if saturationSlider {
                    CustomSlider(value: $saturation, in: saturationRange, colors: [Color(hue: color.hue, saturation: saturationRange.lowerBound, brightness: color.value), Color(hue: color.hue, saturation: saturationRange.upperBound, brightness: color.value)])
                        .tint(color)
                        .onChange(of: saturation) { _, saturation in
                            self.color = Color(hue: color.hue, saturation: saturation, brightness: color.value)
                        }
                }
            }
            
            if opacitySlider, let color {
                CustomSlider(value: $opacity, in: opacityRange, opacityGrid: true, colors: [color.opacity(opacityRange.lowerBound), color.opacity(opacityRange.upperBound)])
                    .tint(color.opacity(opacity))
            }
            
        }
        .onAppear {
            updateState(color: color)
            if isWhite {
                scrollPosition = 1
            } else if isCustom {
                scrollPosition = hueCount + 2
            } else if let color {
                scrollPosition = Int(round(color.hue * Double(hueCount))) + 2
            } else {
                scrollPosition = 0
            }
        }
        .onChange(of: color) { _, color in
            updateState(color: color)
        }
    }
    
    private func updateState(color: Color?) {
        guard let color else {
            isWhite = false
            isCustom = false
            return
        }
        isWhite = color.hue.isApproximately(Color.white.hue) && color.saturation.isApproximately(Color.white.saturation) && color.value.isApproximately(Color.white.value)
        isCustom = !(color.hue * Double(hueCount)).isApproximately((color.hue * Double(hueCount)).rounded())
        if !isWhite && !isCustom {
            if saturationSlider {
                saturation = color.saturation
            }
            if brightnessSlider {
                brightness = color.value
            }
        }
    }
    
    private func colorIcon(_ color: some ShapeStyle, isSelected: Bool, bordered: Bool = true) -> some View {
        shape
            .fill(color)
            .frame(width: 50, height: 50)
            .overlay {
                shape
                    .stroke(isSelected ? .white : .gray, lineWidth: 5)
                    .opacity(bordered ? 1 : 0)
            }
            .frame(width: 55, height: 55)
    }
}
