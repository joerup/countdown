//
//  CountdownBubble.swift
//  Countdown.messages
//
//  Created by Joe Rupertus on 5/30/24.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownBubble: View {
    
    var selectedCountdown: Countdown?
    
    var body: some View {
        if let countdown = selectedCountdown, let destination = countdown.linkURL() {
            Link(destination: destination) {
                CountdownSquare(countdown: countdown)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(15)
        } else {
            Text("No Countdown")
        }
    }
}
