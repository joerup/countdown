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
        case hms
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
                case .hms:
                    HStack {
                        numberUnit(componentsRemaining.hour, unit: "h", size: size)
                        numberUnit(componentsRemaining.minute, unit: "m", size: size)
                        numberUnit(componentsRemaining.second, unit: "s", size: size)
                    }
                case .full:
                    VStack {
                        number(daysRemaining, size: size * (1-CGFloat(String(daysRemaining).count)/10))
                        HStack {
                            numberUnit(componentsRemaining.day, unit: "d", size: size/4)
                            numberUnit(componentsRemaining.hour, unit: "h", size: size/4)
                            numberUnit(componentsRemaining.minute, unit: "m", size: size/4)
                            numberUnit(componentsRemaining.second, unit: "s", size: size/4)
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
    
    private func number(_ value: Int, size: CGFloat) -> some View {
        ZStack {
            if let tintColor = countdown.card?.tintColor, let textStyle = countdown.card?.textStyle {
                Text(String(value))
                    .font(.system(size: size))
                    .fontDesign(textStyle.design)
                    .fontWeight(textStyle.weight)
                    .fontWidth(textStyle.width)
                    .foregroundStyle(tintColor)
                    .lineLimit(0).minimumScaleFactor(0.5)
            }
        }
    }
    
    private func numberUnit(_ value: Int?, unit: String, size: CGFloat) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            if let tintColor = countdown.card?.tintColor {
                Text(String(format: "%02i", abs(value ?? 0)))
                    .font(.system(size: size))
                    .fontWeight(.bold)
                    .fontWidth(.condensed)
                    .foregroundStyle(tintColor)
                    .monospacedDigit()
                ZStack {
                    Text(unit)
                        .font(.system(size: size*5/6, weight: .semibold))
                        .foregroundStyle(tintColor)
                        .fontWidth(.condensed)
                    Text(unit)
                        .font(.system(size: size*5/6, weight: .semibold))
                        .foregroundStyle(.thinMaterial)
                        .fontWidth(.condensed)
                }
            }
        }
    }
}


