//
//  TitleDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct TitleDisplay: View {
    
    @EnvironmentObject private var clock: Clock
    
    var countdown: Countdown
    
    var size: CGFloat
    var alignment: HorizontalAlignment
    
    public init(countdown: Countdown, size: CGFloat, alignment: HorizontalAlignment = .center) {
        self.countdown = countdown
        self.size = size
        self.alignment = alignment
    }
    
    public var body: some View {
        VStack(alignment: alignment) {
            title()
            date()
        }
        .id(clock.tick)
        .environment(\.colorScheme, .light)
    }
    
    private func title() -> some View {
        ZStack {
            if let tintColor = countdown.card?.tint {
                TintedText(tint: tintColor) {
                    Text("\(countdown.displayName)")
                        .font(.system(size: size))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                }
                .frame(height: size)
            }
        }
    }
    
    private func date() -> some View {
        ZStack {
            if let tintColor = countdown.card?.tint {
                HStack(spacing: 3) {
                    TintedText(tint: tintColor) {
                        Text("\(countdown.date.dateString)\(countdown.occasion.includeTime ? " \(countdown.date.timeString)" : "")")
                            .textCase(.uppercase)
                            .font(.system(size: size/2))
                            .fontWeight(.medium)
                            .fontWidth(.condensed)
                            .padding(.bottom, 5)
                    }
                }
                .frame(height: size/2)
            }
        }
    }
}

