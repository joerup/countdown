//
//  CounterDisplay.swift
//  CountdownTime
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
                    number(daysRemaining, size: size * (1-CGFloat(String(daysRemaining).count)/10))
                case .full:
                    VStack {
                        number(componentsRemaining.day, size: size * (1-CGFloat(String(componentsRemaining.day ?? 0).count)/10))
                        ZStack {
                            numberUnit(componentsRemaining.second, unit: "s", size: smaller(ignoreWidth: true)).opacity(0)
                            HStack {
                                numberUnit(componentsRemaining.hour, unit: "h", size: smaller())
                                numberUnit(componentsRemaining.minute, unit: "m", size: smaller())
                                numberUnit(componentsRemaining.second, unit: "s", size: smaller())
                            }
                        }
                        .blur(radius: clock.active ? 0 : 3)
                    }
                }
            }
            .foregroundStyle(.thickMaterial)
            .id(clock.tick)
            .environment(\.colorScheme, .light)
        }
    }
    
    private func smaller(ignoreWidth: Bool = false) -> CGFloat {
        return (countdown.card?.textStyle.width == .expanded && !ignoreWidth ? size*0.85 : size) * 0.3
    }
    private func medium(ignoreWidth: Bool = false) -> CGFloat {
        return (countdown.card?.textStyle.width == .expanded && !ignoreWidth ? size*0.85 : size) * 0.4
    }
    
    @ViewBuilder
    private func number(_ value: Int?, size: CGFloat) -> some View {
        if let value, let tintColor = countdown.card?.tintColor, let textStyle = countdown.card?.textStyle {
            Text(String(value))
                .font(.system(size: size))
                .fontDesign(textStyle.design)
                .fontWeight(textStyle.weight)
                .fontWidth(textStyle.width)
                .foregroundStyle(tintColor)
                .lineLimit(0).minimumScaleFactor(0.5)
        }
    }
    
    private func numberUnit(_ value: Int?, unit: String, size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let value, let tintColor = countdown.card?.tintColor, let textStyle = countdown.card?.textStyle {
                Text(String(format: "%02i", abs(value)))
                    .font(.system(size: size))
                    .fontDesign(textStyle.design)
                    .fontWeight(textStyle.weight)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(tintColor)
                    .monospacedDigit()
                ZStack {
                    Text(unit).foregroundStyle(tintColor)
                    Text(unit).foregroundStyle(.thinMaterial)
                }
                .font(.system(size: size*5/6, weight: .semibold))
                .fontDesign(textStyle.design)
                .fontWeight(textStyle.weight)
                .fontWidth(textStyle.width)
            }
        }
    }
}


