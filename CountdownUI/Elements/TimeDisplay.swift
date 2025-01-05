//
//  CounterDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct TimeDisplay: View {
    
    var days: Int?
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var textColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Font.Weight
    var textOpacity: Double
    var textShadow: Double
    
    var textSize: CGFloat
    
    public init(days: Int? = nil, hours: Int, minutes: Int, seconds: Int, textColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, textOpacity: Double, textShadow: Double, textSize: CGFloat) {
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.textColor = textColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.textOpacity = textOpacity
        self.textShadow = textShadow
        self.textSize = textSize
    }
    
    public var body: some View {
        HStack(spacing: 1) {
            if let days {
                numberUnit(days)
                    .padding(.trailing, 10)
            }
            numberUnit(hours, colon: true)
            numberUnit(minutes, colon: true)
            numberUnit(seconds)
        }
        .foregroundStyle(.thickMaterial)
        .environment(\.colorScheme, .light)
    }
    
    private func numberUnit(_ value: Int?, unit: String? = nil, colon: Bool = false) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let value {
                Text(String(format: "%02i", abs(value)))
                    .font(.system(size: textSize))
                    .fontWeight(textWeight)
                    .fontDesign(textStyle.design)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(textColor)
                    .opacity(textOpacity)
                    .monospacedDigit()
                if let unit {
                    ZStack {
                        Text(unit).foregroundStyle(.white)
                        Text(unit).foregroundStyle(textColor.opacity(0.5))
                    }
                    .font(.system(size: textSize * 0.7))
                    .fontWeight(textWeight)
                    .fontDesign(textStyle.design)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(textColor)
                    .opacity(textOpacity)
                    .padding(.trailing, textSize * 0.3)
                }
                if colon {
                    ZStack {
                        Text(":").foregroundStyle(.white)
                        Text(":").foregroundStyle(textColor.opacity(0.5))
                    }
                    .font(.system(size: textSize * 5 / 6))
                    .fontWeight(textWeight)
                    .fontDesign(textStyle.design)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(textColor)
                    .opacity(textOpacity)
                }
            }
        }
        .lineLimit(0)
        .minimumScaleFactor(0.1)
    }

}




