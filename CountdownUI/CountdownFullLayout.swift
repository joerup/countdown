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
    
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    private var textOpacity: Double
    
    private var titleSize: Double
    private var numberSize: Double
    
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
    
    public var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width
            let titleSize = 1.0
            let numberSize = 1.0
            
            VStack(spacing: 0) {
                TitleDisplay(
                    title: title,
                    tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                    textSize: scale * titleSize * 0.1
                )
                DateDisplay(
                    dateString: dateString,
                    tintColor: tintColor, textWeight: textWeight, textOpacity: textOpacity,
                    textSize: scale * min(1.0, titleSize) * 0.08
                )
                Spacer(minLength: 0)
                DaysDisplay(
                    daysRemaining: daysRemaining,
                    tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                    textSize: scale * numberSize * 0.4
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
