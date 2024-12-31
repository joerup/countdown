//
//  LayoutEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/29/24.
//

import SwiftUI
import CountdownUI
import CountdownData

struct LayoutEditor: View {
    
    @Binding var layout: Card.Layout
    
    var title: String
    var dateString: String
    var daysRemaining: Int
    var timeRemaining: Date.TimeRemaining
    var tintColor: Color
    var textStyle: Card.TextStyle
    var textWeight: Int
    var textOpacity: Double
    
    @State private var layoutType: Card.LayoutType = .standard
    
    @State private var standardOptions: Card.Layout.StandardOptions = .init()
    @State private var bottomOptions: Card.Layout.BottomOptions = .init()
    @State private var timerOptions: Card.Layout.TimerOptions = .init()
    
    private let showLayoutSelector = true
    
    var body: some View {
        VStack {
            if showLayoutSelector {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Card.LayoutType.allCases, id: \.self) { type in
                            Button {
                                self.layoutType = type
                                setLayout()
                            } label: {
                                CountdownLayout(title: title, dateString: dateString, daysRemaining: daysRemaining, timeRemaining: timeRemaining, layout: layout(for: type), tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity)
                                    .padding(16)
                                    .frame(width: 120, height: 120)
                                    .background(Material.ultraThin.opacity(layoutType == type ? 1.0 : 0.25))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                }
                Divider()
                    .padding(.vertical)
            }
            
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
                }
            case .bottom:
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "textformat.characters")
                            .imageScale(.large)
                            .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                            .frame(minWidth: 50)
                        alignmentPicker(value: $bottomOptions.alignment)
                        sizeSlider(value: $bottomOptions.size)
                    }
                    Toggle("Show Date", isOn: $bottomOptions.showDate)
                        .padding()
                        .background(Material.ultraThin.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            case .timer:
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "textformat.characters")
                            .imageScale(.large)
                            .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                            .frame(minWidth: 50)
                        alignmentPicker(value: $timerOptions.titleAlignment)
                        sizeSlider(value: $timerOptions.titleSize)
                    }
                    HStack {
                        Image(systemName: "numbers")
                            .imageScale(.large)
                            .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                            .frame(minWidth: 50)
                        alignmentPicker(value: $timerOptions.numberAlignment)
                        sizeSlider(value: $timerOptions.numberSize)
                    }
                    Toggle("Show Date", isOn: $timerOptions.showDate)
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
            case .bottom(let options):
                self.layoutType = .bottom
                self.bottomOptions = options
            case .timer(let options):
                self.layoutType = .timer
                self.timerOptions = options
            }
        }
        .onChange(of: standardOptions) { _, _ in
            setLayout()
        }
        .onChange(of: bottomOptions) { _, _ in
            setLayout()
        }
        .onChange(of: timerOptions) { _, _ in
            setLayout()
        }
    }
    
    private func setLayout() {
        self.layout = layout(for: layoutType)
    }
    
    private func layout(for type: Card.LayoutType) -> Card.Layout {
        switch type {
        case .standard:
            return .standard(standardOptions)
        case .bottom:
            return .bottom(bottomOptions)
        case .timer:
            return .timer(timerOptions)
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
