//
//  ColorGradientMenu.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/12/23.
//

import SwiftUI

struct ColorGradientMenu: ViewModifier {
    
    @Binding var isPresented: Bool
    
    var onSelect: ([Color]) -> Void
    
    @State private var colors: [Color] = []
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    VStack {
                        HStack {
                            ForEach($colors, id: \.self) { $color in
                                ColorPicker("", selection: $color)
                            }
                            Button {
                                colors.append(.white)
                            } label: {
                                Image(systemName: "plus.circle")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.leading, 5)
                            Spacer()
                                .layoutPriority(1)
                        }
                        .padding(.horizontal)
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                            .shadow(radius: 20)
                            .padding()
                    }
                    .navigationTitle("Gradient")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .cancel) {
                                isPresented = false
                            } label: {
                                Text("Cancel")
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isPresented = false
                                onSelect(colors)
                            } label: {
                                Text("Add")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
    }
}

extension View {
    func gradientMenu(isPresented: Binding<Bool>, onSelect: @escaping ([Color]) -> Void) -> some View {
        modifier(ColorGradientMenu(isPresented: isPresented, onSelect: onSelect))
    }
}
