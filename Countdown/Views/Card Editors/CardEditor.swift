//
//  CardEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 10/21/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CardEditor: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var card: Card
    
    var edgeInsets: EdgeInsets
    
    var dismiss: () -> Void
    
    @State private var background: Card.Background?
    @State private var backgroundTransforms: Card.BackgroundTransforms?
    
    @State private var backgroundColor: Color?
    @State private var backgroundFade: Double = 0
    @State private var backgroundBlur: Double = 0
    @State private var backgroundSaturation: Double = 0
    @State private var backgroundBrightness: Double = 0
    @State private var backgroundContrast: Double = 0
    
    @State private var textColor: Color = .white
    @State private var textStyle: Card.TextStyle = .standard
    @State private var textWeight: Int = Font.Weight.medium.rawValue
    @State private var textOpacity: Double = 1.0
    @State private var textShadow: Double = 0
    @State private var titleSize: Double = 1.0
    @State private var numberSize: Double = 1.0
    
    @State private var forceUpdate: Bool = false
    
    private var title: String {
        card.countdown?.displayName ?? "Countdown"
    }
    private var dateString: String {
        card.countdown?.dateString ?? ""
    }
    private var daysRemaining: Int {
        card.countdown?.daysRemaining ?? 0
    }
    private var timeRemaining: Date.TimeRemaining {
        card.countdown?.timeRemaining ?? .zero
    }
    
    var body: some View {
        VStack(spacing: 0) {
        }
        .onAppear {
            setStates()
            background = card.countdown?.currentBackground
            backgroundTransforms = card.backgroundTransforms
        }
        .onChange(of: textColor) { _, color in
            card.textColor = color
        }
        .onChange(of: textStyle) { _, style in
            card.textStyle = style
        }
        .onChange(of: textWeight) { _, weight in
            card.textWeight = weight
        }
        .onChange(of: textOpacity) { _, opacity in
            card.textOpacity = opacity
        }
        .onChange(of: textShadow) { _, shadow in
            card.textShadow = shadow
        }
        .onChange(of: titleSize) { _, size in
            card.titleSize = size
        }
        .onChange(of: numberSize) { _, size in
            card.numberSize = size
        }
        .onChange(of: backgroundColor) { _, color in
            card.backgroundColor = color
        }
        .onChange(of: backgroundFade) { _, fade in
            card.backgroundFade = fade
        }
        .onChange(of: backgroundBlur) { _, blur in
            card.backgroundBlur = blur
        }
        .onChange(of: backgroundSaturation) { _, saturation in
            card.backgroundSaturation = saturation
        }
        .onChange(of: backgroundBrightness) { _, brightness in
            card.backgroundBrightness = brightness
        }
        .onChange(of: backgroundContrast) { _, contrast in
            card.backgroundContrast = contrast
        }
    }
}
