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
    var size: CGFloat
    
    var tintColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Font.Weight
    
    public init(daysRemaining: Int, tintColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, size: CGFloat) {
        self.daysRemaining = daysRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.size = size
    }
    
    public var body: some View {
        number(daysRemaining, size: fit(daysRemaining))
            .foregroundStyle(.thickMaterial)
            .environment(\.colorScheme, .light)
            .shadow(radius: 10)
            .padding(.bottom, 0.25 * (size - fit(daysRemaining)))
    }
    
    private func fit(_ number: Int) -> CGFloat {
        return size * (1-CGFloat(String(number).count)/10)
    }
    
    @ViewBuilder
    private func number(_ value: Int?, size: CGFloat) -> some View {
        if let value {
            Text(String(value))
                .font(.system(size: size))
                .fontWeight(textWeight)
                .fontDesign(textStyle.design)
                .fontWidth(textStyle.width)
                .foregroundStyle(tintColor)
                .lineLimit(0).minimumScaleFactor(0.5)
        }
    }
}
