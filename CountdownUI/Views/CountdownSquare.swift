//
//  CountdownSquare.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI
import CountdownData

public struct CountdownSquare: View {
    
    private var title: String
    private var dateString: String
    private var daysRemaining: Int
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var background: Card.Background?
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.tintColor = countdown.currentTintColor
        self.textStyle = countdown.currentTextStyle
        self.background = countdown.currentBackgroundIcon
    }
    
    public var body: some View {
        CountdownSquareText(title: title, dateString: dateString, daysRemaining: daysRemaining, tintColor: tintColor, textStyle: textStyle)
            .padding([.horizontal, .top])
            .padding(.bottom, 5)
            .background {
                BackgroundDisplay(background: background, blurRadius: 1)
                    .ignoresSafeArea()
                    .padding(.bottom, -5)
            }
    }
}

public struct CountdownSquareText: View {
    
    private var title: String
    private var dateString: String
    private var daysRemaining: Int
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.tintColor = countdown.currentTintColor
        self.textStyle = countdown.currentTextStyle
    }
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.daysRemaining = instance.daysRemaining
        self.tintColor = instance.tintColor
        self.textStyle = instance.textStyle
    }
    public init(title: String, dateString: String, daysRemaining: Int, tintColor: Color, textStyle: Card.TextStyle) {
        self.title = title
        self.dateString = dateString
        self.daysRemaining = daysRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                TitleDisplay(title: title, date: dateString, tintColor: tintColor, titleSize: geometry.size.height*0.135, dateSize: geometry.size.height*0.1, alignment: .leading)
                    .frame(height: geometry.size.height*0.5)
                HStack(alignment: .bottom) {
                    Spacer()
                    DaysDisplay(daysRemaining: daysRemaining, tintColor: tintColor, textStyle: textStyle, size: geometry.size.height*0.5)
                        .padding(.trailing, 3)
                }
                .frame(height: geometry.size.height*0.5)
            }
        }
    }
}
