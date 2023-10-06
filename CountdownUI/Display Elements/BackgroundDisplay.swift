//
//  BackgroundDisplay.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
    
    var card: Card
    var blurRadius: Double = 0
    
    public init(card: Card) {
        self.card = card
    }
    public init(card: Card, blurRadius: Double = 0) {
        self.card = card
        self.blurRadius = blurRadius
    }
    
    public var body: some View {
        Group {
            switch card.background {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blurRadius)
            case .gradient(let colors):
                LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            }
        }
    }
}
