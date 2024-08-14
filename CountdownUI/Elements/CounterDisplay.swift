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
    var size: CGFloat
    
    var tintColor: Color
    
    public init(timeRemaining: Date.TimeRemaining, tintColor: Color, size: CGFloat) {
        self.timeRemaining = timeRemaining
        self.tintColor = tintColor
        self.size = size
    }
    
    public var body: some View {
        HStack {
            numberUnit(timeRemaining.day, unit: "d", size: size)
            numberUnit(timeRemaining.hour, unit: "h", size: size)
            numberUnit(timeRemaining.minute, unit: "m", size: size)
            numberUnit(timeRemaining.second, unit: "s", size: size)
        }
        .foregroundStyle(.thickMaterial)
        .environment(\.colorScheme, .light)
        .shadow(radius: 10)
    }
    
    private func numberUnit(_ value: Int?, unit: String, size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let value {
                Text(String(format: "%02i", abs(value)))
                    .font(.system(size: size))
                    .fontWeight(.bold)
                    .fontWidth(.condensed)
                    .foregroundStyle(tintColor)
                    .minimumScaleFactor(0.5)
                    .monospacedDigit()
                ZStack {
                    Text(unit).foregroundStyle(tintColor)
                    Text(unit).foregroundStyle(.thinMaterial.opacity(0.5))
                }
                .font(.system(size: size*5/6))
                .fontWeight(.bold)
                .fontWidth(.condensed)
            }
        }
        .frame(height: size*1.2)
    }
}




