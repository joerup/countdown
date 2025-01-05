//
//  CountdownLayout.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 12/30/24.
//

import SwiftUI
import CountdownData

public struct CountdownLayout: View {
    
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
    
    private let scale: CGFloat = 300
    
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
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.daysRemaining = instance.daysRemaining
        self.timeRemaining = instance.timeRemaining
        self.textColor = instance.textColor
        self.textStyle = instance.textStyle
        self.textWeight = Font.Weight(rawValue: instance.textWeight)
        self.textOpacity = instance.textOpacity
        self.textShadow = instance.textShadow
        self.titleSize = instance.titleSize
        self.numberSize = instance.numberSize
    }
    public init(title: String, dateString: String, daysRemaining: Int, timeRemaining: Date.TimeRemaining, textColor: Color, textStyle: Card.TextStyle, textWeight: Int, textOpacity: Double, textShadow: Double, titleSize: Double, numberSize: Double) {
        self.title = title
        self.dateString = dateString
        self.daysRemaining = daysRemaining
        self.timeRemaining = timeRemaining
        self.textColor = textColor
        self.textStyle = textStyle
        self.textWeight = Font.Weight(rawValue: textWeight)
        self.textOpacity = textOpacity
        self.textShadow = textShadow
        self.titleSize = titleSize
        self.numberSize = numberSize
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Aligner(.leading) {
                    TitleDisplay(
                        title: title,
                        textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                        textSize: scale * titleSize * 0.15,
                        alignment: .leading
                    )
                    DateDisplay(
                        dateString: dateString,
                        textColor: textColor, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                        textSize: scale * min(1.0, titleSize) * 0.12,
                        alignment: .leading
                    )
                }
                Spacer(minLength: 0)
                Aligner(.trailing) {
                    DaysDisplay(
                        days: daysRemaining,
                        textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow,
                        textSize: scale * numberSize * 0.5
                    )
                }
                .padding(.trailing, scale * numberSize * 0.04)
                .padding(.bottom, -scale * numberSize * 0.1)
            }
            .shadow(color: Color(white: 0.3).opacity(textShadow), radius: 10)
            .frame(width: scale, height: scale)
            .scaleEffect(geometry.size.width/scale)
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

