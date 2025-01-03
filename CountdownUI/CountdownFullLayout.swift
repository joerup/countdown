//
//  CountdownFullLayout.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 1/2/25.
//

import SwiftUI
import CountdownData

public struct CountdownFullLayout: View {
    
    private var title: String
    private var dateString: String
    
    private var daysRemaining: Int
    private var timeRemaining: Date.TimeRemaining
    
    private var textColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    private var textOpacity: Double
    private var textShadow: Double
    
    private var titleSize: Double
    private var numberSize: Double
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.timeRemaining = countdown.timeRemaining
        self.textColor = countdown.currentTextColor
        self.textStyle = countdown.currentTextStyle
        self.textWeight = Font.Weight(rawValue: countdown.currentTextWeight)
        self.textOpacity = countdown.currentTextOpacity
        self.textShadow = countdown.currentTextShadow
        self.titleSize = countdown.currentTitleSize
        self.numberSize = countdown.currentNumberSize
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width
            VStack(spacing: 0) {
                TitleDisplay(
                    title: title,
                    textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                    textSize: scale * titleSize * 0.1
                )
                DateDisplay(
                    dateString: dateString,
                    textColor: textColor, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                    textSize: scale * min(1.0, titleSize) * 0.08
                )
                Spacer(minLength: 0)
                DaysDisplay(
                    daysRemaining: timeRemaining.day,
                    textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                    textSize: scale * numberSize * 0.4
                )
                TimeDisplay(
                    timeRemaining: timeRemaining,
                    textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                    textSize: scale * numberSize * 0.1
                )
            }
            .shadow(color: Color(white: 0.3).opacity(textShadow), radius: 10)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
