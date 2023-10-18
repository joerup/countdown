//
//  TitleDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct TitleDisplay: View {
    
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
        .id(countdown.daysRemaining) // keep this
    }
    
    private func date() -> some View {
        ZStack {
            if let tintColor = countdown.card?.tint {
                TintedText(tint: tintColor) {
                    Text("\(countdown.date.string)")
                        .textCase(.uppercase)
                        .font(.system(size: size/2))
                        .fontWeight(.medium)
                        .fontWidth(.condensed)
                        .padding(.bottom, 5)
                }
                .frame(height: size/2)
            }
        }
    }
}

