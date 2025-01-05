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
    private var backgroundDim: Double
    private var backgroundBrightness: Double
    private var backgroundSaturation: Double
    private var backgroundContrast: Double
    
    public init(countdown: Countdown) {
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
        self.background = countdown.currentBackground
        self.backgroundColor = countdown.currentBackgroundColor
        self.backgroundFade = countdown.currentBackgroundFade
        self.backgroundBlur = countdown.currentBackgroundBlur
        self.backgroundDim = countdown.currentBackgroundDim
        self.backgroundBrightness = countdown.currentBackgroundBrightness
        self.backgroundSaturation = countdown.currentBackgroundSaturation
        self.backgroundContrast = countdown.currentBackgroundContrast
    }
    
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.daysRemaining = instance.daysRemaining
        self.timeRemaining = instance.timeRemaining
        self.textColor = instance.textColor
        self.textStyle = instance.textStyle
        self.textWeight = instance.textWeight
        self.textOpacity = instance.textOpacity
        self.textShadow = instance.textShadow
        self.titleSize = instance.titleSize
        self.numberSize = instance.numberSize
        self.background = instance.currentBackground
        self.backgroundColor = instance.backgroundColor
        self.backgroundFade = instance.backgroundFade
        self.backgroundBlur = instance.backgroundBlur
        self.backgroundDim = instance.backgroundDim
        self.backgroundBrightness = instance.backgroundBrightness
        self.backgroundSaturation = instance.backgroundSaturation
        self.backgroundContrast = instance.backgroundContrast
    }
    
    public var body: some View {
        GeometryReader { geometry in
            CountdownLayout(title: title, dateString: dateString, daysRemaining: daysRemaining, timeRemaining: timeRemaining, textColor: textColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity, textShadow: textShadow, titleSize: titleSize, numberSize: numberSize)
                .padding([.horizontal, .top], geometry.size.width*0.1)
                .padding(.bottom, geometry.size.width*0.04)
                .background {
                    BackgroundDisplay(background: background?.square, color: backgroundColor, fade: backgroundFade, blur: backgroundBlur, dim: backgroundDim, brightness: backgroundBrightness, saturation: backgroundSaturation, contrast: backgroundContrast)
                        .padding(.bottom, -geometry.size.width*0.01)
                }
        }
    }
}
