//
//  EditorMenu.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/27/24.
//

import SwiftUI

struct EditorMenu<Content: View>: View {
    var title: String
    var content: () -> Content
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.foreground)
                    }
                }
            ScrollView {
                content()
                    .padding(.vertical)
            }
        }
        .safeAreaPadding()
        .ignoresSafeArea(edges: .bottom)
    }
}
