//
//  TitleDisplay.swift
//  CountdownUI
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
    
    var tintColor: Color {
        countdown.card?.tintColor ?? .white
    }
    
    public init(countdown: Countdown, size: CGFloat, alignment: HorizontalAlignment = .center) {
        self.countdown = countdown
        self.size = size
        self.alignment = alignment
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: size*0.15) {
            title()
            date()
            Spacer(minLength: 0)
        }
        .id(clock.tick)
        .environment(\.colorScheme, .light)
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    private func title() -> some View {
        Text("\(countdown.displayName)")
            .font(.system(size: size))
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(tintColor)
            .lineLimit(2)
            .multilineTextAlignment(alignment == .leading ? .leading : .center)
    }
    
    @ViewBuilder
    private func date() -> some View {
        Text("\(countdown.date.dateString)\(countdown.occasion.includeTime ? " \(countdown.date.timeString)" : "")")
            .textCase(.uppercase)
            .font(.system(size: size*0.6))
            .fontWeight(.medium)
            .fontWidth(.condensed)
            .foregroundStyle(tintColor)
    }
}

