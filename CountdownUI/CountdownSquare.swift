//
//  CountdownSquare.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI
import CountdownData

public struct CountdownSquare: View {
    
    private var countdownID: UUID
    private var title: String
    private var dateString: String
    
    private var daysRemaining: Int
    private var timeRemaining: Date.TimeRemaining
    
    private var textColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Int
    private var textOpacity: Double
    private var textShadow: Double
    
    private var titleSize: Double
    private var numberSize: Double
    
    private var background: Card.Background?
    private var backgroundColor: Color?
    private var backgroundFade: Double
    private var backgroundBlur: Double
    private var backgroundBrightness: Double
    private var backgroundSaturation: Double
    private var backgroundContrast: Double
    
    public init(countdown: Countdown) {
        self.countdownID = countdown.id
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.timeRemaining = countdown.timeRemaining
        self.textColor = countdown.currentTextColor
        self.textStyle = countdown.currentTextStyle
        self.textWeight = countdown.currentTextWeight
        self.textOpacity = countdown.currentTextOpacity
        self.textShadow = countdown.currentTextShadow
        self.titleSize = countdown.currentTitleSize
        self.numberSize = countdown.currentNumberSize
        self.background = countdown.currentBackgroundIcon
        self.backgroundColor = countdown.currentBackgroundColor
        self.backgroundFade = countdown.currentBackgroundFade
        self.backgroundBlur = countdown.currentBackgroundBlur
        self.backgroundBrightness = countdown.currentBackgroundBrightness
        self.backgroundSaturation = countdown.currentBackgroundSaturation
        self.backgroundContrast = countdown.currentBackgroundContrast
    }
    
    public var body: some View {
        GeometryReader { geometry in
            CountdownLayout(title: title, dateString: dateString, daysRemaining: daysRemaining, timeRemaining: timeRemaining, textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow, titleSize: titleSize, numberSize: numberSize)
                .padding([.horizontal, .top], geometry.size.width*0.1)
                .padding(.bottom, geometry.size.width*0.04)
                .background {
                    BackgroundDisplay(background: background, color: backgroundColor, fade: backgroundFade, blur: backgroundBlur, brightness: backgroundBrightness, saturation: backgroundSaturation, contrast: backgroundContrast)
                        .padding(.bottom, -geometry.size.width*0.01)
                }
        }
    }
}
