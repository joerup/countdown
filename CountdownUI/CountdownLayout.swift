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
    
    private var layout: Card.Layout
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    private var textOpacity: Double
    
    private let scale: CGFloat = 300
    
    public init(countdown: Countdown) {
        self.title = countdown.displayName
        self.dateString = countdown.dateString
        self.daysRemaining = countdown.daysRemaining
        self.timeRemaining = countdown.timeRemaining
        self.layout = countdown.currentLayout
        self.tintColor = countdown.currentTintColor
        self.textStyle = countdown.currentTextStyle
        self.textWeight = Font.Weight(rawValue: countdown.currentTextWeight)
        self.textOpacity = countdown.currentTextOpacity
    }
    public init(instance: CountdownInstance) {
        self.title = instance.displayName
        self.dateString = instance.dateString
        self.daysRemaining = instance.daysRemaining
        self.timeRemaining = instance.timeRemaining
        self.layout = instance.layout
        self.tintColor = instance.tintColor
        self.textStyle = instance.textStyle
        self.textWeight = Font.Weight(rawValue: instance.textWeight)
        self.textOpacity = instance.textOpacity
    }
    public init(title: String, dateString: String, daysRemaining: Int, timeRemaining: Date.TimeRemaining, layout: Card.Layout, tintColor: Color, textStyle: Card.TextStyle, textWeight: Int, textOpacity: Double) {
        self.title = title
        self.dateString = dateString
        self.daysRemaining = daysRemaining
        self.timeRemaining = timeRemaining
        self.layout = layout
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = Font.Weight(rawValue: textWeight)
        self.textOpacity = textOpacity
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Group {
                switch layout {
                case .standard(let layoutOptions):
                    VStack(spacing: 0) {
                        Aligner(layoutOptions.titleAlignment) {
                            TitleDisplay(
                                title: title,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.titleSize * 0.15,
                                alignment: layoutOptions.titleAlignment
                            )
                            if layoutOptions.showDate {
                                DateDisplay(
                                    dateString: dateString,
                                    tintColor: tintColor, textWeight: textWeight, textOpacity: textOpacity,
                                    textSize: scale * min(1.0, layoutOptions.titleSize) * 0.12,
                                    alignment: layoutOptions.titleAlignment
                                )
                            }
                        }
                        Spacer(minLength: 0)
                        Aligner(layoutOptions.numberAlignment) {
                            DaysDisplay(
                                daysRemaining: daysRemaining,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.numberSize * 0.5
                            )
                        }
                        .padding(layoutOptions.numberAlignment.oppositeEdge, scale * layoutOptions.numberSize * 0.04)
                        .padding(.bottom, -scale * layoutOptions.numberSize * 0.08)
                    }
                case .bottom(let layoutOptions):
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Aligner(layoutOptions.alignment) {
                            DaysDisplay(
                                daysRemaining: daysRemaining,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.size * 0.16,
                                showDaysText: true
                            )
                            TitleDisplay(
                                title: title,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.size * 0.18,
                                alignment: layoutOptions.alignment
                            )
                            if layoutOptions.showDate {
                                DateDisplay(
                                    dateString: dateString,
                                    tintColor: tintColor, textWeight: textWeight, textOpacity: textOpacity,
                                    textSize: scale * min(1.0, layoutOptions.size) * 0.12,
                                    alignment: layoutOptions.alignment
                                )
                            }
                        }
                    }
                case .timer(let layoutOptions):
                    VStack(spacing: 0) {
                        Aligner(layoutOptions.titleAlignment) {
                            TitleDisplay(
                                title: title,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.titleSize * 0.15,
                                alignment: layoutOptions.titleAlignment
                            )
                            if layoutOptions.showDate {
                                DateDisplay(
                                    dateString: dateString,
                                    tintColor: tintColor, textWeight: textWeight, textOpacity: textOpacity,
                                    textSize: scale * min(1.0, layoutOptions.titleSize) * 0.12,
                                    alignment: layoutOptions.titleAlignment
                                )
                            }
                        }
                        Spacer(minLength: 0)
                        Aligner(layoutOptions.numberAlignment) {
                            DaysDisplay(
                                daysRemaining: timeRemaining.day,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.numberSize * 0.2
                            )
                            TimeDisplay(
                                timeRemaining: timeRemaining,
                                tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity,
                                textSize: scale * layoutOptions.numberSize * 0.15
                            )
                        }
                    }
                }
            }
            .frame(width: scale, height: scale)
            .scaleEffect(geometry.size.width/scale)
            .frame(width: geometry.size.width, height: geometry.size.width)
        }
    }
}

