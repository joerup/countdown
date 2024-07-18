//
//  CardView.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownData

public struct CountdownCard: View {
    
    @Environment(Clock.self) var clock
    
    private var title: String
    private var dateString: String
    private var counter: Countdown.Counter
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var background: Card.Background?
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.counter = .full(countdown.date.daysRemaining(), countdown.date.componentsRemaining())
        self.tintColor = countdown.currentTintColor ?? .white
        self.textStyle = countdown.currentTextStyle ?? .standard
        self.background = countdown.currentBackground
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleDisplay(title: title, date: dateString, tintColor: tintColor, size: 40)
                Spacer()
                CounterDisplay(value: counter, tintColor: tintColor, textStyle: textStyle, size: 150)
            }
            .padding(.bottom, 50)
            .padding(.top, 80)
            .padding(20)
            .frame(width: geometry.size.width)
//            .confettiCannon(counter: 1, num: 100, rainHeight: 1000, openingAngle: .zero, closingAngle: .radians(2 * .pi))
            .background {
                BackgroundDisplay(background: background)
            }
        }
    }
}

