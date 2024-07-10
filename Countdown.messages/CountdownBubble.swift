//
//  CountdownBubble.swift
//  Countdown.messages
//
//  Created by Joe Rupertus on 5/30/24.
//

import SwiftUI
import CountdownData
import CountdownUI
import SwiftData

struct CountdownBubble: View {
    
    var instance: CountdownInstance
    var existingCountdown: Countdown?
    var sent: Bool
    
    var update: (CountdownInstance?,Bool?) -> ()
    var append: (Countdown) -> ()
    
    var body: some View {
        if let existingCountdown, instance.compareTo(countdown: existingCountdown), let url = existingCountdown.linkURL() {
            Link(destination: url) {
                CountdownSquare(countdown: existingCountdown)
            }
            .frame(maxWidth: 200)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .aspectRatio(1.0, contentMode: .fill)
            .padding(sent ? .trailing : .leading, 10)
            .background(.fill)
        } else {
            CountdownSquare(instance: instance)
                .frame(maxWidth: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .aspectRatio(1.0, contentMode: .fill)
                .padding(sent ? .trailing : .leading, 10)
                .background(.fill)
                .overlay(alignment: .topTrailing) {
                    saveButton
                }
        }
    }
    
    private var saveButton: some View {
        Button {
            if let existingCountdown {
                existingCountdown.match(instance)
            } else {
                let countdown = Countdown(from: instance)
                append(countdown)
            }
            update(instance, sent)
        } label: {
            Image(systemName: "square.and.arrow.down")
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.bottom, 3)
                .background(.pink)
                .clipShape(Capsule())
                .padding(.trailing, sent ? 7 : 0)
                .padding(5)
        }
    }
}
