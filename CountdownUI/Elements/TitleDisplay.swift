//
//  TitleDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct TitleDisplay: View {
    
    private var title: String
    
    private var textColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    private var textOpacity: Double
    private var textShadow: Double
    
    private var textSize: CGFloat
    
    private var capitalized: Bool 
    private var alignment: Card.Alignment
    
    public init(title: String, textColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, textOpacity: Double, textShadow: Double, textSize: CGFloat, capitalized: Bool = false, alignment: Card.Alignment = .center) {
        self.title = title
        self.textColor = textColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.textOpacity = textOpacity
        self.textShadow = textShadow
        self.textSize = textSize
        self.capitalized = capitalized
        self.alignment = alignment
    }
    
    public var body: some View {
        Text(title)
            .font(.system(size: textSize))
            .fontWeight(textWeight.bolder())
            .fontDesign(textStyle.design)
            .fontWidth(textStyle.width)
            .foregroundStyle(textColor)
            .opacity(textOpacity)
            .lineLimit(2)
            .multilineTextAlignment(alignment.textAlignment)
            .textCase(capitalized ? .uppercase : nil)
            .environment(\.colorScheme, .light)
    }
}

public struct DateDisplay: View {
    
    private var dateString: String
    
    private var textColor: Color
    private var textWeight: Font.Weight
    private var textOpacity: Double
    private var textShadow: Double
    
    private var textSize: CGFloat
    
    private var titleCapitalized: Bool
    private var alignment: Card.Alignment
    
    public init(dateString: String, textColor: Color, textWeight: Font.Weight, textOpacity: Double, textShadow: Double, textSize: CGFloat, titleCapitalized: Bool = false, alignment: Card.Alignment = .center) {
        self.dateString = dateString
        self.textColor = textColor
        self.textWeight = textWeight
        self.textOpacity = textOpacity
        self.textShadow = textShadow
        self.textSize = textSize
        self.titleCapitalized = titleCapitalized
        self.alignment = alignment
    }
    
    public var body: some View {
        Text(dateString)
            .textCase(.uppercase)
            .font(.system(size: textSize))
            .fontWeight(textWeight)
            .fontWidth(.condensed)
            .foregroundStyle(textColor)
            .opacity(textOpacity)
            .lineLimit(2)
            .multilineTextAlignment(alignment.textAlignment)
            .fixedSize(horizontal: false, vertical: true)
            .environment(\.colorScheme, .light)
    }
}

