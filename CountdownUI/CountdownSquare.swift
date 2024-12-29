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
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Int
    private var background: Card.Background?
    private var backgroundColor: Color
    private var backgroundFade: Double
    private var backgroundBlur: Double
    
    public init(countdown: Countdown) {
        self.countdownID = countdown.id
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.tintColor = countdown.currentTintColor
        self.textStyle = countdown.currentTextStyle
        self.textWeight = countdown.currentTextWeight
        self.background = countdown.currentBackground
        self.backgroundColor = countdown.currentBackgroundColor
        self.backgroundFade = countdown.currentBackgroundFade
        self.backgroundBlur = countdown.currentBackgroundBlur
    }
    
    public var body: some View {
        GeometryReader { geometry in
            CountdownSquareText(title: title, dateString: dateString, daysRemaining: daysRemaining, tintColor: tintColor, textStyle: textStyle, textWeight: textWeight)
                .padding([.horizontal, .top], geometry.size.width*0.1)
                .padding(.bottom, geometry.size.width*0.04)
                .background {
                    BackgroundDisplay(background: background, color: backgroundColor, fade: backgroundFade, blur: backgroundBlur)
                        .padding(.bottom, -geometry.size.width*0.01)
                }
        }
    }
}

public struct CountdownSquareText: View {
    
    private var title: String
    private var dateString: String
    private var daysRemaining: Int
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    
    private let scale: CGFloat = 300
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.tintColor = countdown.currentTintColor
        self.textStyle = countdown.currentTextStyle
        self.textWeight = Font.Weight(rawValue: countdown.currentTextWeight)
    }
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.daysRemaining = instance.daysRemaining
        self.tintColor = instance.tintColor
        self.textStyle = instance.textStyle
        self.textWeight = Font.Weight(rawValue: instance.textWeight)
    }
    public init(title: String, dateString: String, daysRemaining: Int, tintColor: Color, textStyle: Card.TextStyle, textWeight: Int) {
        self.title = title
        self.dateString = dateString
        self.daysRemaining = daysRemaining
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = Font.Weight(rawValue: textWeight)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                TitleDisplay(title: title, date: dateString, tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, titleSize: scale*0.15, dateSize: scale*0.12, alignment: .leading)
                Spacer(minLength: 0)
                HStack(alignment: .bottom) {
                    Spacer(minLength: 0)
                    DaysDisplay(daysRemaining: daysRemaining, tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, size: scale*0.5)
                        .padding(.trailing, scale*0.04)
                        .padding(.bottom, -scale*0.08)
                }
            }
            .frame(width: scale, height: scale)
            .scaleEffect(geometry.size.width/scale)
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}
