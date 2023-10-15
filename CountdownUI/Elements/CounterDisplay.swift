//
//  CounterDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct CounterDisplay: View {
    
    var countdown: Countdown
    
    var type: DisplayType
    var size: CGFloat
    
    public init(countdown: Countdown, type: DisplayType = .days, size: CGFloat) {
        self.countdown = countdown
        self.type = type
        self.size = size
    }
    
    public enum DisplayType {
        case days
        case hms
        case full
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Group {
                switch type {
                case .days:
                    number(countdown.daysRemaining, size: size)
                case .hms:
                    HStack {
                        numberUnit(countdown.componentsRemaining.hour, unit: "h", size: size)
                        numberUnit(countdown.componentsRemaining.minute, unit: "m", size: size)
                        numberUnit(countdown.componentsRemaining.second, unit: "s", size: size)
                    }
                case .full:
                    VStack {
                        number(countdown.daysRemaining, size: size * (1-CGFloat(String(countdown.daysRemaining).count)/10))
                        HStack {
                            numberUnit(countdown.componentsRemaining.day, unit: "d", size: size/4)
                            numberUnit(countdown.componentsRemaining.hour, unit: "h", size: size/4)
                            numberUnit(countdown.componentsRemaining.minute, unit: "m", size: size/4)
                            numberUnit(countdown.componentsRemaining.second, unit: "s", size: size/4)
                        }
                    }
                }
            }
            .foregroundStyle(.thickMaterial)
            .environment(\.colorScheme, .light)
        }
    }
    
    private func number(_ value: Int, size: CGFloat) -> some View {
        ZStack {
            if let tintColor = countdown.card?.tint, let textStyle = countdown.card?.textStyle {
                TintedText(tint: tintColor) {
                    Text(String(value))
                        .font(.system(size: size))
                        .fontDesign(textStyle.design)
                        .fontWeight(textStyle.weight)
                        .fontWidth(textStyle.width)
                        .lineLimit(0).minimumScaleFactor(0.5)
                }
                .shadow(radius: 10)
            }
        }
    }
    
    private func numberUnit(_ value: Int?, unit: String, size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let tintColor = countdown.card?.tint {
                TintedText(tint: tintColor) {
                    Text(String(format: "%02i", abs(value ?? 0)))
                        .font(.system(size: size))
                        .fontWeight(.bold)
                        .fontWidth(.condensed)
                        .monospacedDigit()
                }
                Text(unit)
                    .font(.system(size: size*5/6, weight: .semibold))
                    .foregroundStyle(.thinMaterial)
                    .fontWidth(.condensed)
            }
        }
        .shadow(radius: 10)
    }
}


