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
    var arrangement: Arrangement
    
    public init(countdown: Countdown, size: CGFloat, arrangement: Arrangement = .vertical(alignment: .center)) {
        self.countdown = countdown
        self.size = size
        self.arrangement = arrangement
    }
    
    public enum Arrangement {
        case vertical(alignment: HorizontalAlignment)
        case horizontal(alignment: VerticalAlignment)
    }
    
    public var body: some View {
        Group {
            switch arrangement {
            case .vertical(let alignment):
                VStack(alignment: alignment, content: content)
            case .horizontal(let alignment):
                HStack(alignment: alignment, content: content)
            }
        }
        .environment(\.colorScheme, .light)
    }
    
    @ViewBuilder
    private func content() -> some View {
        if let tintColor = countdown.card?.tint {
            TintedText(tint: tintColor) {
                Text("\(countdown.displayName)")
                    .font(.system(size: size))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .frame(height: size)
            }
            if case .horizontal(_) = arrangement {
                Spacer()
            }
            TintedText(tint: tintColor) {
                Text("\(countdown.date.string)")
                    .textCase(.uppercase)
                    .font(.system(size: size/2))
                    .fontWeight(.medium)
                    .fontWidth(.condensed)
                    .padding(.bottom, 5)
                    .frame(height: size/2)
            }
        }
    }
}

