//
//  CounterDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct CounterDisplay: View {
    
    var timeRemaining: Date.TimeRemaining
    
    var tintColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Font.Weight
    
    var size: CGFloat
    
    public init(timeRemaining: Date.TimeRemaining, tintColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, size: CGFloat) {
        self.timeRemaining = timeRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.size = size
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            numberUnit(timeRemaining.day, unit: "d", size: size)
            numberUnit(timeRemaining.hour, unit: "h", size: size)
            numberUnit(timeRemaining.minute, unit: "m", size: size)
            numberUnit(timeRemaining.second, unit: "s", size: size)
        }
        .foregroundStyle(.thickMaterial)
        .environment(\.colorScheme, .light)
    }
    
    private func numberUnit(_ value: Int?, unit: String, size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let value {
                HStack(spacing: 2) {
                    ForEach(Array(String(format: "%02i", abs(value))), id: \.self) { char in
                        Text(String(char))
                            .font(.system(size: size))
                            .fontWeight(.bold)
                            .fontDesign(.monospaced)
                            .foregroundStyle(tintColor)
                            .minimumScaleFactor(0.5)
                            .monospacedDigit()
//                            .background {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Material.ultraThin.opacity(0.5))
//                            }
                    }
                }
                ZStack {
                    Text(unit).foregroundStyle(.white)
                    Text(unit).foregroundStyle(tintColor.opacity(0.5))
                }
                .font(.system(size: size * 5 / 6))
                .fontWeight(.regular)
                .fontWidth(.condensed)
            }
        }
    }

}




