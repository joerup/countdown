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
    
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    private var textOpacity: Double
    
    private var textSize: CGFloat
    
    private var capitalized: Bool 
    private var alignment: Card.Alignment
    
    public init(title: String, tintColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, textOpacity: Double, textSize: CGFloat, capitalized: Bool = false, alignment: Card.Alignment = .center) {
        self.title = title
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.textOpacity = textOpacity
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
            .foregroundStyle(tintColor)
            .opacity(textOpacity)
            .lineLimit(2)
            .multilineTextAlignment(alignment.textAlignment)
            .textCase(capitalized ? .uppercase : nil)
            .environment(\.colorScheme, .light)
            .shadow(radius: 10)
    }
}

public struct DateDisplay: View {
    
    private var dateString: String
    
    private var tintColor: Color
    private var textWeight: Font.Weight
    private var textOpacity: Double
    
    private var textSize: CGFloat
    
    private var titleCapitalized: Bool
    private var alignment: Card.Alignment
    
    public init(dateString: String, tintColor: Color, textWeight: Font.Weight, textOpacity: Double, textSize: CGFloat, titleCapitalized: Bool = false, alignment: Card.Alignment = .center) {
        self.dateString = dateString
        self.tintColor = tintColor
        self.textWeight = textWeight
        self.textOpacity = textOpacity
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
            .foregroundStyle(tintColor)
            .opacity(textOpacity)
            .lineLimit(2)
            .multilineTextAlignment(alignment.textAlignment)
            .fixedSize(horizontal: false, vertical: true)
            .environment(\.colorScheme, .light)
            .shadow(radius: 10)
    }
}

