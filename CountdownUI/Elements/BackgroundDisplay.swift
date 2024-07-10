//
//  BackgroundDisplay.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import CountdownData

public struct BackgroundDisplay: View {
    
    private var background: Card.Background?
    private var blurRadius: Double = 0
    
    public init(background: Card.Background?, blurRadius: Double = 0) {
        self.background = background
        self.blurRadius = blurRadius
    }
    
    public var body: some View {
        Group {
            switch background {
            case .photo(let photo):
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: blurRadius)
            case .loading, nil:
                Rectangle().fill(Color.init(red: 163/255, green: 55/255, blue: 68/255))
            }
        }
    }
}
