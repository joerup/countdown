//
//  CountdownSquare.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI
import CountdownData

public struct CountdownSquare: View {
    
    var countdown: Countdown
    
    public init(countdown: Countdown) {
        self.countdown = countdown
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            TitleDisplay(countdown: countdown, size: 25, alignment: .leading)
            Spacer(minLength: 0)
            HStack {
                Spacer()
                CounterDisplay(countdown: countdown, size: 80)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 7)
        .background(BackgroundDisplay(countdown: countdown, blurRadius: 1))
        .cornerRadius(20)
        .aspectRatio(1.0, contentMode: .fill)
    }
}
