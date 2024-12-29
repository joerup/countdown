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
    
    @State private var titleAlignment: Card.Alignment = .leading
    @State private var titleSize: Double = 1.0
    @State private var numberAlignment: Card.Alignment = .trailing
    @State private var numberSize: Double = 1.0
    @State private var showDate: Bool = true
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "textformat.characters")
                        .imageScale(.large)
                        .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                        .frame(minWidth: 50)
                    alignmentPicker(value: $titleAlignment)
                    sizeSlider(value: $titleSize)
                }
                HStack {
                    Image(systemName: "numbers")
                        .imageScale(.large)
                        .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                        .frame(minWidth: 50)
                    alignmentPicker(value: $numberAlignment)
                    sizeSlider(value: $numberSize)
                }
                Toggle("Show Date", isOn: $showDate)
                    .padding()
                    .background(Material.ultraThin.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .tint(.pink)
        .onAppear {
            switch layout {
            case .standard(let titleAlignment, let titleSize, let numberAlignment, let numberSize, let showDate):
                self.layoutType = .standard
                self.titleAlignment = titleAlignment
                self.titleSize = titleSize
                self.numberAlignment = numberAlignment
                self.numberSize = numberSize
                self.showDate = showDate
            }
        }
        .onChange(of: titleAlignment) { _, _ in
            setLayout()
        }
        .onChange(of: titleSize) { _, _ in
            setLayout()
        }
        .onChange(of: numberAlignment) { _, _ in
            setLayout()
        }
        .onChange(of: numberSize) { _, _ in
            setLayout()
        }
        .onChange(of: showDate) { _, _ in
            setLayout()
        }
    }
    
    private func setLayout() {
        switch layoutType {
        case .standard:
            self.layout = .standard(titleAlignment: titleAlignment, titleSize: titleSize, numberAlignment: numberAlignment, numberSize: numberSize, showDate: showDate)
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
