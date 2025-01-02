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
    
    private let showLayoutSelector = false
    
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
//                                CountdownLayout(title: title, dateString: dateString, daysRemaining: daysRemaining, timeRemaining: timeRemaining, tintColor: tintColor, textStyle: textStyle, textWeight: textWeight, textOpacity: textOpacity)
//                                    .padding(16)
//                                    .frame(width: 120, height: 120)
//                                    .background(Material.ultraThin.opacity(layoutType == type ? 1.0 : 0.25))
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
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
                    alignmentSizeRow(icon: "textformat.characters", alignment: $standardOptions.titleAlignment, size: $standardOptions.titleSize)
                    alignmentSizeRow(icon: "numbers", alignment: $standardOptions.numberAlignment, size: $standardOptions.numberSize)
                    
                    Toggle("Show Date", isOn: $standardOptions.showDate)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Material.ultraThin).opacity(0.5))
                }
            case .bottom:
                VStack(spacing: 15) {
                    alignmentSizeRow(icon: "textformat.characters", alignment: $bottomOptions.alignment, size: $bottomOptions.size)
                    
                    Toggle("Show Date", isOn: $bottomOptions.showDate)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Material.ultraThin).opacity(0.5))
                }
            case .timer:
                VStack(spacing: 15) {
                    alignmentSizeRow(icon: "textformat.characters", alignment: $timerOptions.titleAlignment, size: $timerOptions.titleSize)
                    alignmentSizeRow(icon: "numbers", alignment: $timerOptions.numberAlignment, size: $timerOptions.numberSize)
                    
                    Toggle("Show Date", isOn: $timerOptions.showDate)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Material.ultraThin).opacity(0.5))
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
    
    private func alignmentSizeRow(icon: String, alignment: Binding<Card.Alignment>, size: Binding<Double>) -> some View {
        HStack {
            Image(systemName: icon)
                .imageScale(.large)
                .fontWeight(.semibold)
                .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                .frame(minWidth: 50)
            
            HStack(spacing: 0) {
                ForEach(Card.Alignment.allCases, id: \.self) { align in
                    Button {
                        alignment.wrappedValue = align
                    } label: {
                        Image(systemName: align.imageName)
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(alignment.wrappedValue == align ? 0.5 : 0.1)))
                    }
                }
            }
            
            CustomSlider(value: size, in: 0.8...1.25, mask: true, colors: [.pink.lighter(), .pink])
                .padding(.leading, 3)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Material.ultraThin).opacity(0.5))
    }
}
