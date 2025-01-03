//
//  CounterDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct TimeDisplay: View {
    
    var timeRemaining: Date.TimeRemaining
    
    var tintColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Font.Weight
    var textOpacity: Double
    var textShadow: Double
    
    var textSize: CGFloat
    
    public init(timeRemaining: Date.TimeRemaining, tintColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, textOpacity: Double, textShadow: Double, textSize: CGFloat) {
        self.timeRemaining = timeRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.textOpacity = textOpacity
        self.textShadow = textShadow
        self.textSize = textSize
    }
    
    public var body: some View {
        HStack(spacing: 1) {
            numberUnit(timeRemaining.hour, colon: true)
            numberUnit(timeRemaining.minute, colon: true)
            numberUnit(timeRemaining.second)
        }
        .foregroundStyle(.thickMaterial)
        .environment(\.colorScheme, .light)
    }
    
    private func numberUnit(_ value: Int?, colon: Bool = false) -> some View {
        HStack(spacing: 1) {
            if let value {
                Text(String(format: "%02i", abs(value)))
                    .font(.system(size: textSize))
                    .fontWeight(textWeight)
                    .fontDesign(textStyle.design)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(tintColor)
                    .opacity(textOpacity)
                    .monospacedDigit()
                if colon {
                    ZStack {
                        Text(":").foregroundStyle(.white)
                        Text(":").foregroundStyle(tintColor.opacity(0.5))
                    }
                    .font(.system(size: textSize * 5 / 6))
                    .fontWeight(textWeight)
                    .fontDesign(textStyle.design)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(tintColor)
                    .opacity(textOpacity)
                }
            }
        }
    }

}




