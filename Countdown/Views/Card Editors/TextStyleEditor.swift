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
                                .background(Material.ultraThin.opacity(textStyle == style ? 1.0 : 0.25))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.bottom)
            
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
                    shape: .widening,
                    colors: [.pink]
                )
                .tint(.pink)
                Image(systemName: "textformat")
                    .imageScale(.large)
                    .fontWeight(.heavy)
                    .foregroundStyle(.secondary)
                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
            }
            
            Divider()
                .padding(.vertical)
            
            CustomColorPicker(color: $tintColor, shape: Circle(), sliderValue: .saturation)
            
            CustomSlider(value: $textOpacity, in: 0.15...1, colors: [tintColor.opacity(0.15), tintColor])
                .tint(tintColor.opacity(textOpacity))
                .padding()
        }
    }
}
