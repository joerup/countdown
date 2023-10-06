//
//  CountdownSquare.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI

struct CountdownSquare: View {
    
    var countdown: Countdown
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleDisplay(countdown: countdown, size: 25, arrangement: .vertical(alignment: .leading))
            Spacer(minLength: 0)
            HStack {
                Spacer()
                CounterDisplay(countdown: countdown, size: 55)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 10)
        .transition(.opacity)
        .background(BackgroundDisplay(background: countdown.background, blurRadius: 2))
        .cornerRadius(20)
        .aspectRatio(1.0, contentMode: .fill)
    }
}
