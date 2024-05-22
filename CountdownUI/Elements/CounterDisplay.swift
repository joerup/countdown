//
//  CounterDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct CounterDisplay: View {
    
    @EnvironmentObject private var clock: Clock
    
    var countdown: Countdown
    
    var type: DisplayType
    var size: CGFloat
    
    var tintColor: Color {
        countdown.card?.tintColor ?? .white
    }
    var textStyle: Card.TextStyle {
        countdown.card?.textStyle ?? .standard
    }
    
    public init(countdown: Countdown, type: DisplayType = .days, size: CGFloat) {
        self.countdown = countdown
        self.type = type
        self.size = size
    }
    
    public enum DisplayType {
        case days
        case full
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            Group {
                let daysRemaining = clock.daysRemaining(for: countdown)
                let componentsRemaining = clock.componentsRemaining(for: countdown)
                switch type {
                case .days:
                    number(daysRemaining, size: fit(daysRemaining))
                        .frame(height: size)
                case .full:
                    VStack(spacing: 0) {
                        number(daysRemaining, size: fit(daysRemaining))
                        HStack {
                            numberUnit(componentsRemaining.day, unit: "d", size: smaller)
                            numberUnit(componentsRemaining.hour, unit: "h", size: smaller)
                            numberUnit(componentsRemaining.minute, unit: "m", size: smaller)
                            numberUnit(componentsRemaining.second, unit: "s", size: smaller)
                        }
                        .blur(radius: clock.active ? 0 : 3)
                    }
                }
            }
            .foregroundStyle(.thickMaterial)
            .environment(\.colorScheme, .light)
            .shadow(radius: 10)
        }
    }
    
    private var smaller: CGFloat {
        return size * 0.25
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
    
    private func numberUnit(_ value: Int?, unit: String, size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let value {
                Text(String(format: "%02i", abs(value)))
                    .font(.system(size: textStyle.width == .expanded ? size*0.8 : size))
                    .fontDesign(textStyle.design)
                    .fontWeight(textStyle.weight)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(tintColor)
                    .minimumScaleFactor(0.5)
                    .monospacedDigit()
                ZStack {
                    Text(unit).foregroundStyle(tintColor)
                    Text(unit).foregroundStyle(.thinMaterial.opacity(0.5))
                }
                .font(.system(size: (textStyle.width == .expanded ? size*0.8 : size)*5/6))
                .fontDesign(textStyle.design)
                .fontWeight(textStyle.weight)
                .fontWidth(textStyle.width)
                .fontWidth(.condensed)
            }
        }
        .frame(height: size*1.2)
    }
}


