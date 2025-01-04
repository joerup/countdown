//
//  DaysDisplay.swift
//
//
//  Created by Joe Rupertus on 7/22/24.
//

import SwiftUI
import CountdownData

public struct DaysDisplay: View {
    
    var days: Int
    
    var textColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Font.Weight
    var textOpacity: Double
    var textShadow: Double
    
    var textSize: CGFloat
    
    var showDaysText: Bool
    
    public init(days: Int, textColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, textOpacity: Double, textShadow: Double, textSize: CGFloat, showDaysText: Bool = false) {
        self.days = days
        self.textColor = textColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.textSize = textSize
        self.textOpacity = textOpacity
        self.textShadow = textShadow
        self.showDaysText = showDaysText
    }
    
    public var body: some View {
        number(days, size: fit(days))
            .foregroundStyle(.thickMaterial)
            .environment(\.colorScheme, .light)
            .padding(.bottom, 0.25 * (textSize - fit(days)))
    }
    
    private func fit(_ number: Int) -> CGFloat {
        return textSize * (1-CGFloat(String(number).count)/10)
    }
    
    @ViewBuilder
    private func number(_ value: Int?, size: CGFloat) -> some View {
        if let value {
            Text("\(value)\(showDaysText ? " days" : "")")
                .font(.system(size: size))
                .fontWeight(textWeight)
                .fontDesign(textStyle.design)
                .fontWidth(textStyle.width)
                .foregroundStyle(textColor)
                .opacity(textOpacity)
                .lineLimit(0)
        }
    }
}
