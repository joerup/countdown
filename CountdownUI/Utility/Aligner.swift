//
//  Aligner.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 12/30/24.
//

import SwiftUI
import CountdownData

struct Aligner<Content: View>: View {
    
    var alignment: Card.Alignment
    
    @ViewBuilder var content: () -> Content
    
    init(_ alignment: Card.Alignment, @ViewBuilder content: @escaping () -> Content) {
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        switch alignment {
        case .leading:
            HStack {
                VStack(alignment: alignment.horizontalAlignment, spacing: 0, content: content)
                Spacer(minLength: 0)
            }
        case .center:
            HStack {
                Spacer(minLength: 0)
                VStack(alignment: alignment.horizontalAlignment, spacing: 0, content: content)
                Spacer(minLength: 0)
            }
        case .trailing:
            HStack {
                Spacer(minLength: 0)
                VStack(alignment: alignment.horizontalAlignment, spacing: 0, content: content)
            }
        }
    }
}
