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
    
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    private var textOpacity: Double
    
    private var titleSize: Double
    private var numberSize: Double
    
    private let scale: CGFloat = 300
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.timeRemaining = countdown.timeRemaining
        self.tintColor = countdown.currentTintColor
        self.textStyle = countdown.currentTextStyle
        self.textWeight = Font.Weight(rawValue: countdown.currentTextWeight)
        self.textOpacity = countdown.currentTextOpacity
        self.titleSize = countdown.currentTitleSize
        self.numberSize = countdown.currentNumberSize
    }
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.daysRemaining = instance.daysRemaining
        self.timeRemaining = instance.timeRemaining
        self.tintColor = instance.tintColor
        self.textStyle = instance.textStyle
        self.textWeight = Font.Weight(rawValue: instance.textWeight)
        self.textOpacity = instance.textOpacity
        self.titleSize = instance.titleSize
        self.numberSize = instance.numberSize
    }
    public init(title: String, dateString: String, daysRemaining: Int, timeRemaining: Date.TimeRemaining, tintColor: Color, textStyle: Card.TextStyle, textWeight: Int, textOpacity: Double, titleSize: Double, numberSize: Double) {
        self.title = title
        self.dateString = dateString
        self.daysRemaining = daysRemaining
        self.timeRemaining = timeRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = Font.Weight(rawValue: textWeight)
        self.textOpacity = textOpacity
        self.titleSize = titleSize
        self.numberSize = numberSize
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Aligner(.leading) {
                    TitleDisplay(
                        title: title,
                        tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                        textSize: scale * titleSize * 0.15,
                        alignment: .leading
                    )
                    DateDisplay(
                        dateString: dateString,
                        tintColor: tintColor, textWeight: textWeight, textOpacity: textOpacity,
                        textSize: scale * min(1.0, titleSize) * 0.12,
                        alignment: .leading
                    )
                }
                Spacer(minLength: 0)
                Aligner(.trailing) {
                    DaysDisplay(
                        daysRemaining: daysRemaining,
                        tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                        textSize: scale * numberSize * 0.5
                    )
                }
                .padding(.trailing, scale * numberSize * 0.04)
                .padding(.bottom, -scale * numberSize * 0.08)
            }
            .frame(width: scale, height: scale)
            .scaleEffect(geometry.size.width/scale)
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

