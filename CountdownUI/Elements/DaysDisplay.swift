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
    
    public init(daysRemaining: Int, tintColor: Color, textStyle: Card.TextStyle, size: CGFloat) {
        self.daysRemaining = daysRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.size = size
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            number(daysRemaining, size: fit(daysRemaining))
                .frame(height: size)
                .foregroundStyle(.thickMaterial)
                .environment(\.colorScheme, .light)
                .shadow(radius: 10)
        }
    }
    
    private func fit(_ number: Int) -> CGFloat {
        return size * (1-CGFloat(String(number).count)/10)
    }
    
    @ViewBuilder
    private func number(_ value: Int?, size: CGFloat) -> some View {
        if let value {
            Text(String(value))
                .font(.system(size: textStyle.width == .expanded ? size*0.9 : size))
                .fontDesign(textStyle.design)
                .fontWeight(textStyle.weight)
                .fontWidth(textStyle.width)
                .foregroundStyle(tintColor)
                .lineLimit(0).minimumScaleFactor(0.5)
        }
    }
}
