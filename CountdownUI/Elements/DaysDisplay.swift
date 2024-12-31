//
//  DaysDisplay.swift
//
//
//  Created by Joe Rupertus on 7/22/24.
//

import SwiftUI
import CountdownData

public struct DaysDisplay: View {
    
    var daysRemaining: Int
    
    var tintColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Font.Weight
    var textOpacity: Double
    
    var textSize: CGFloat
    
    var showDaysText: Bool
    
    public init(daysRemaining: Int, tintColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, textOpacity: Double, textSize: CGFloat, showDaysText: Bool = false) {
        self.daysRemaining = daysRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.textSize = textSize
        self.textOpacity = textOpacity
        self.showDaysText = showDaysText
    }
    
    public var body: some View {
        number(daysRemaining, size: fit(daysRemaining))
            .foregroundStyle(.thickMaterial)
            .environment(\.colorScheme, .light)
            .shadow(radius: 10)
            .padding(.bottom, 0.25 * (textSize - fit(daysRemaining)))
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
                .foregroundStyle(tintColor)
                .opacity(textOpacity)
                .lineLimit(0)
        }
    }
}
