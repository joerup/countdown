//
//  CountdownSquare.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI
import CountdownData

public struct CountdownSquare: View {
    
    var countdown: Countdown
    var card: Card?
    
    public init(countdown: Countdown, card: Card? = nil) {
        self.countdown = countdown
        self.card = card ?? countdown.card
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                TitleDisplay(countdown: countdown, card: card, size: geometry.size.height*0.135, alignment: .leading)
                    .frame(height: geometry.size.height*0.5)
                HStack(alignment: .bottom) {
                    Spacer()
                    CounterDisplay(countdown: countdown, card: card, size: geometry.size.height*0.5)
                }
                .frame(height: geometry.size.height*0.5)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 7)
        .background(BackgroundDisplay(countdown: countdown, card: card, blurRadius: 1))
        .cornerRadius(20)
        .aspectRatio(1.0, contentMode: .fill)
        .frame(maxWidth: 200)
    }
}
