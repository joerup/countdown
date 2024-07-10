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
    
    private var size: CGFloat
    private var alignment: HorizontalAlignment

    public init(title: String, date: String, tintColor: Color, size: CGFloat, alignment: HorizontalAlignment = .center) {
        self.titleString = title
        self.dateString = date
        self.tintColor = tintColor
        self.size = size
        self.alignment = alignment
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: size*0.15) {
            title()
            date()
            Spacer(minLength: 0)
        }
        .environment(\.colorScheme, .light)
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    private func title() -> some View {
        Text(titleString)
            .font(.system(size: size))
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(tintColor)
            .lineLimit(2)
            .multilineTextAlignment(alignment == .leading ? .leading : .center)
    }
    
    @ViewBuilder
    private func date() -> some View {
        Text(dateString)
            .textCase(.uppercase)
            .font(.system(size: size*0.6))
            .fontWeight(.medium)
            .fontWidth(.condensed)
            .foregroundStyle(tintColor)
    }
}

