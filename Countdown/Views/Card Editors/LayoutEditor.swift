//
//  LayoutEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/29/24.
//

import SwiftUI
import CountdownData

struct LayoutEditor: View {
    
    @Binding var layout: Card.Layout
    
    @State private var layoutType: Card.LayoutType = .standard
    
    @State private var standardOptions: Card.Layout.StandardOptions = .init()
    
    var body: some View {
        VStack {
            switch layoutType {
            case .standard:
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "textformat.characters")
                            .imageScale(.large)
                            .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                            .frame(minWidth: 50)
                        alignmentPicker(value: $standardOptions.titleAlignment)
                        sizeSlider(value: $standardOptions.titleSize)
                    }
                    HStack {
                        Image(systemName: "numbers")
                            .imageScale(.large)
                            .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                            .frame(minWidth: 50)
                        alignmentPicker(value: $standardOptions.numberAlignment)
                        sizeSlider(value: $standardOptions.numberSize)
                    }
                    Toggle("Show Date", isOn: $standardOptions.showDate)
                        .padding()
                        .background(Material.ultraThin.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Toggle("Title Capitalized", isOn: $standardOptions.titleCapitalized)
                        .padding()
                        .background(Material.ultraThin.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .tint(.pink)
        .onAppear {
            switch layout {
            case .standard(let options):
                self.layoutType = .standard
                self.standardOptions = options
            }
        }
        .onChange(of: standardOptions) { _, _ in
            setLayout()
        }
    }
    
    private func setLayout() {
        switch layoutType {
        case .standard:
            self.layout = .standard(standardOptions)
        }
    }
    
    private func alignmentPicker(value: Binding<Card.Alignment>) -> some View {
        HStack(spacing: 2) {
            ForEach(Card.Alignment.allCases, id: \.self) { align in
                Button {
                    value.wrappedValue = align
                } label: {
                    Image(systemName: align.imageName)
                        .padding()
                        .background(Circle().fill(Material.ultraThin.opacity(value.wrappedValue == align ? 1.0 : 0.25)))
                }
            }
        }
    }
    
    private func sizeSlider(value: Binding<Double>) -> some View {
        HStack {
            Image(systemName: "textformat.size.smaller")
                .imageScale(.large)
                .foregroundStyle(.secondary)
                .dynamicTypeSize(..<DynamicTypeSize.xLarge)
            Slider(value: value, in: 0.8...1.25)
            Image(systemName: "textformat.size.larger")
                .imageScale(.large)
                .foregroundStyle(.secondary)
                .dynamicTypeSize(..<DynamicTypeSize.xLarge)
        }
        .padding(.leading)
    }
}
