//
//  CountdownFullRow.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/29/23.
//

import SwiftUI
import CountdownData

public struct CountdownFullRow: View {
        
    var countdown: Countdown
    
    public init(countdown: Countdown) {
        self.countdown = countdown
    }
    
    public var body: some View {
        VStack {
            HStack {
                TitleDisplay(countdown: countdown, size: 25, arrangement: .horizontal(alignment: .center))
                Spacer()
            }
            CounterDisplay(countdown: countdown, type: .hms, size: 40)
                .padding(.top, 50)
        }
        .padding()
        .transition(.opacity)
        .background(BackgroundDisplay(card: countdown.card, blurRadius: 5))
        .cornerRadius(20)
    }
}
