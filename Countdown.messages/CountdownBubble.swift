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
    var add: (Countdown) -> ()
    var edit: (Countdown) -> ()
    
    var body: some View {
        if let existingCountdown, instance.compareTo(countdown: existingCountdown), let url = existingCountdown.getURL() {
            Link(destination: url) {
                CountdownSquareText(instance: instance)
            }
            .padding(sent ? .trailing : .leading, 7)
            .padding(.top, 37.5)
            .padding(.leading, 12.5)
            .padding(.trailing, 15)
            .padding(.bottom, 5)
            .background(background)
        } else {
            CountdownSquareText(instance: instance)
                .padding(sent ? .trailing : .leading, 7)
                .padding(.top, 37.5)
                .padding(.leading, 12.5)
                .padding(.trailing, 15)
                .padding(.bottom, 5)
                .background(background)
                .overlay(alignment: .topTrailing) {
                    saveButton
                }
        }
    }
    
    private var background: some View {
        BackgroundDisplay(background: instance.currentBackgroundIcon, color: instance.backgroundColor, fade: instance.backgroundFade, blurRadius: 1)
    }
    
    private var saveButton: some View {
        Button {
            if let existingCountdown {
                existingCountdown.match(instance)
                edit(existingCountdown)
            } else {
                let countdown = Countdown(from: instance)
                add(countdown)
            }
            update(instance, sent)
        } label: {
            Image(systemName: "square.and.arrow.down")
                .foregroundStyle(.blue)
                .padding(.horizontal, 3)
                .padding(.bottom, 3)
                .padding(4)
                .background(.background.opacity(0.7))
                .clipShape(Circle())
                .overlay { Circle().stroke(.gray, lineWidth: 1) }
                .padding(.trailing, sent ? 7 : 0)
                .padding(7)
        }
    }
}
