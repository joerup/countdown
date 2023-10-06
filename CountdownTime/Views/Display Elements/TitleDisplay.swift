//
//  TitleDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/30/23.
//

import SwiftUI

struct TitleDisplay: View {
    
    var countdown: Countdown
    var textDesign: Countdown.TextDesign? 
    
    var size: CGFloat
    var arrangement: Arrangement = .vertical(alignment: .center)
    
    enum Arrangement {
        case vertical(alignment: HorizontalAlignment)
        case horizontal(alignment: VerticalAlignment)
    }
    
    var body: some View {
        Group {
            switch arrangement {
            case .vertical(let alignment):
                VStack(alignment: alignment, content: content)
            case .horizontal(let alignment):
                HStack(alignment: alignment, content: content)
            }
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
        Text("\(countdown.name)")
            .font(.system(size: size))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .foregroundStyle(.thickMaterial)
            .frame(height: size)
        if case .horizontal(_) = arrangement {
            Spacer()
        }
        Text("\(countdown.date.string)")
            .textCase(.uppercase)
            .font(.system(size: size/2))
            .fontWeight(.regular)
            .fontWidth(.condensed)
            .foregroundStyle(.regularMaterial)
            .padding(.bottom, 5)
            .frame(height: size/2)
    }
}

