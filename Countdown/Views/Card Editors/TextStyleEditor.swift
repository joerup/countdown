//
//  TextStyleEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/29/24.
//

import SwiftUI
import CountdownData

struct TextStyleEditor: View {
    
    @Binding var textStyle: Card.TextStyle
    @Binding var textWeight: Int
    @Binding var tintColor: Color
    @Binding var textOpacity: Double
    @Binding var textShadow: Double
    
    @Binding var titleSize: Double
    @Binding var numberSize: Double
    
    @State private var scrollPosition: Int?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Card.TextStyle.allCases, id: \.self) { style in
                        Button {
                            textStyle = style
                        } label: {
                            Text("12")
                                .font(.largeTitle)
                                .fontWeight(Font.Weight(rawValue: textWeight))
                                .fontDesign(style.design)
                                .fontWidth(style.width)
                                .foregroundStyle(textStyle == style ? .pink : .black)
                                .lineLimit(0).minimumScaleFactor(0.5)
                                .frame(width: 70, height: 70)
                                .background(Color.white.opacity(textStyle == style ? 0.5 : 0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .id(style.rawValue)
                    }
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            .padding(.bottom)
            .onAppear {
                scrollPosition = textStyle.rawValue
            }
            
            HStack {
                Image(systemName: "textformat")
                    .imageScale(.large)
                    .fontWeight(.light)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                CustomSlider(
                    value: Binding(
                        get: { Double(textWeight) },
                        set: { textWeight = Int(round($0)) }
                    ),
                    in: Double(Font.Weight.minimum + 1)...Double(Font.Weight.maximum - 1),
                    mask: true,
                    widen: true,
                    colors: [.pink]
                )
                .tint(.pink)
                Image(systemName: "textformat")
                    .imageScale(.large)
                    .fontWeight(.heavy)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
            }
            .padding(8)
            .background(Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Divider()
                .padding(.vertical)
            
            HStack {
                HStack {
                    Image(systemName: "textformat.characters")
                        .imageScale(.large)
                        .foregroundStyle(.secondary)
                        .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                    CustomSlider(value: $titleSize, in: 0.8...1.25, mask: true, colors: [.pink.lighter(), .pink])
                        .padding(.leading, 3)
                }
                .padding(8)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                HStack {
                    Image(systemName: "numbers")
                        .imageScale(.large)
                        .foregroundStyle(.secondary)
                        .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                    CustomSlider(value: $numberSize, in: 0.8...1.25, mask: true, colors: [.pink.lighter(), .pink])
                        .padding(.leading, 3)
                }
                .padding(8)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Divider()
                .padding(.vertical)
            
            CustomColorPicker(color: Binding(get: { tintColor }, set: { color in if let color { tintColor = color } }), opacity: $textOpacity, shape: Circle(), sliderValue: .saturation, opacityRange: 0.15...1)
            
            Divider()
                .padding(.vertical)
            
            CustomSlider(value: $textShadow, in: 0...1, opacityGrid: true, colors: [.clear, Color(white: 0.3).opacity(0.8)])
                .tint(Color(white: 0.3).opacity(textShadow))
        }
    }
}
