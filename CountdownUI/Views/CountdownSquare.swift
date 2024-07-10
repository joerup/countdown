//
//  CountdownSquare.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI
import CountdownData

public struct CountdownSquare: View {
    
    @EnvironmentObject var clock: Clock
    
    private var title: String
    private var dateString: String
    private var counter: Countdown.Counter
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var background: Card.Background?
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.counter = .days(countdown.date.daysRemaining())
        self.tintColor = countdown.card?.tintColor ?? .white
        self.textStyle = countdown.card?.textStyle ?? .standard
        self.background = countdown.currentBackgroundIcon
    }
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.counter = .days(instance.date.daysRemaining(relativeTo: instance.timestamp))
        self.tintColor = instance.tintColor
        self.textStyle = instance.textStyle
        self.background = instance.currentBackgroundIcon
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                TitleDisplay(title: title, date: dateString, tintColor: tintColor, size: geometry.size.height*0.135, alignment: .leading)
                    .frame(height: geometry.size.height*0.5)
                HStack(alignment: .bottom) {
                    Spacer()
                    CounterDisplay(value: counter, tintColor: tintColor, textStyle: textStyle, size: geometry.size.height*0.5)
                        .padding(.trailing, 3)
                }
                .frame(height: geometry.size.height*0.5)
            }
        }
        .padding([.horizontal, .top])
        .padding(.bottom, 5)
        .background {
            BackgroundDisplay(background: background, blurRadius: 1)
                .ignoresSafeArea()
                .padding(.bottom, -5)
        }
    }
}
