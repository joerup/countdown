//
//  TitleDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI
import CountdownData

public struct TitleDisplay: View {
    
    private var titleString: String
    private var dateString: String
    
    private var tintColor: Color
    private var textStyle: Card.TextStyle
    private var textWeight: Font.Weight
    
    private var titleSize: CGFloat
    private var dateSize: CGFloat
    
    private var showDate: Bool
    private var titleCapitalized: Bool
    private var alignment: HorizontalAlignment

    public init(title: String, date: String, tintColor: Color, textStyle: Card.TextStyle, textWeight: Font.Weight, titleSize: CGFloat, dateSize: CGFloat, showDate: Bool, titleCapitalized: Bool, alignment: HorizontalAlignment = .center) {
        self.titleString = title
        self.dateString = date
        self.tintColor = tintColor
        self.textStyle = textStyle
        self.textWeight = textWeight
        self.titleSize = titleSize
        self.dateSize = dateSize
        self.showDate = showDate
        self.titleCapitalized = titleCapitalized
        self.alignment = alignment
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: titleSize*0.15) {
            title()
            if showDate {
                date()
            }
            Spacer(minLength: 0)
        }
        .environment(\.colorScheme, .light)
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    private func title() -> some View {
        Text(titleString)
            .font(.system(size: titleSize))
            .fontWeight(textWeight.bolder())
            .fontDesign(textStyle.design)
            .fontWidth(textStyle.width)
            .foregroundStyle(tintColor)
            .lineLimit(2)
            .multilineTextAlignment(alignment == .leading ? .leading : alignment == .trailing ? .trailing : .center)
            .textCase(titleCapitalized ? .uppercase : nil)
    }
    
    @ViewBuilder
    private func date() -> some View {
        Text(dateString)
            .textCase(.uppercase)
            .font(.system(size: dateSize))
            .fontWeight(textWeight)
            .fontWidth(.condensed)
            .foregroundStyle(tintColor)
            .lineLimit(2)
            .multilineTextAlignment(alignment == .leading ? .leading : alignment == .trailing ? .trailing : .center)
            .fixedSize(horizontal: false, vertical: true)
            .minimumScaleFactor(0.5)
    }
}

