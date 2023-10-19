//
//  CountdownRow.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI

struct CountdownRow: View {
    
    var countdown: Countdown
    
    var body: some View {
        HStack {
            TitleDisplay(countdown: countdown, size: 25, arrangement: .vertical(alignment: .leading))
            Spacer()
            CounterDisplay(countdown: countdown, size: 50)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .transition(.opacity)
        .background(BackgroundDisplay(background: countdown.background, blurRadius: 5))
        .cornerRadius(20)
    }
}
