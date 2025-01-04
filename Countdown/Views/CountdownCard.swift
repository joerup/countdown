//
//  CardView.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 5/6/23.
//

import SwiftUI
import CountdownUI
import CountdownData
import ConfettiSwiftUI

public struct CountdownCard: View {
    
    @Environment(Clock.self) private var clock
    @Environment(\.scenePhase) private var scenePhase
    
    var countdown: Countdown
    var size: CGSize
    var edgeInsets: EdgeInsets
    var fullScreen: Bool
    
    var animation: Namespace.ID
    
    @Binding var editCountdown: Bool
    
    @State private var shareCountdown = false
    @State private var deleteCountdown = false
    
    private var topPadding: CGFloat {
        fullScreen ? 0 : 15
    }
    private var totalWidth: CGFloat {
        size.width + (fullScreen ? (edgeInsets.leading + edgeInsets.trailing) : 0)
    }
    private var totalHeight: CGFloat {
        size.height + (fullScreen ? (edgeInsets.bottom + edgeInsets.top) : 0)
    }
    
    public var body: some View {
        let squareSize = min(size.width * 0.65, 400)
        CountdownFullLayout(countdown: countdown)
            .padding([.horizontal, .bottom])
            .padding(.vertical, 40)
            .padding(.top, topPadding)
            .padding(20)
            .frame(width: size.width, height: size.height)
            .sheet(isPresented: $editCountdown) {
                let sheetHeight = size.height + (fullScreen ? edgeInsets.bottom : 0) - topPadding - squareSize - 65
                CountdownEditor(countdown: countdown, isEditing: $editCountdown, sheetHeight: sheetHeight)
                    .interactiveDismissDisabled()
            }
            .background {
                BackgroundDisplay(background: countdown.currentBackground?.full, color: countdown.currentBackgroundColor, fade: countdown.currentBackgroundFade, blur: countdown.currentBackgroundBlur, brightness: countdown.currentBackgroundBrightness, saturation: countdown.currentBackgroundSaturation, contrast: countdown.currentBackgroundContrast)
                    .overlay(alignment: .bottom) {
                        LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
                            .frame(height: size.height/3)
                    }
                    .frame(width: totalWidth, height: totalHeight)
                    .clipShape(RoundedRectangle(cornerRadius: fullScreen ? 0 : 40))
                    .clipped()
                    .ignoresSafeArea(edges: .vertical)
                    .id(clock.tick)
            }
            .overlay(alignment: .top) {
                header
                    .padding(.top, topPadding)
            }
            .sheet(isPresented: $shareCountdown) {
                if let countdown = clock.selectedCountdown {
                    ShareMenu(countdown: countdown)
                        .presentationBackground(Material.thin)
                }
            }
            .alert("Delete \(clock.selectedCountdown?.name ?? "Countdown")", isPresented: $deleteCountdown) {
                Button("Cancel", role: .cancel) {
                    deleteCountdown = false
                }
                Button("Delete", role: .destructive) {
                    if let countdown = clock.selectedCountdown {
                        clock.delete(countdown)
                        clock.select(nil)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this countdown? This action cannot be undone.")
            }
    }
    
    private var header: some View {
        HStack(spacing: 15) {
            
            if !editCountdown {
                Button {
                    withAnimation {
                        editCountdown.toggle()
                    }
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .opacity(0.7)
                        .padding(5)
                }
                .tint(.white)
            }
            
//            if editCountdown {
//                Button {
//                    editDestination.toggle()
//                } label: {
//                    Image(systemName: "calendar")
//                        .opacity(0.9)
//                        .padding(5)
//                }
//                .tint(.white)
//                
//                Button {
//                    deleteCountdown.toggle()
//                } label: {
//                    Image(systemName: "trash")
//                        .opacity(0.9)
//                        .padding(5)
//                }
//                .tint(.white)
//            }
            
            Spacer()
            
            if fullScreen && !editCountdown {
                Button {
                    withAnimation {
                        clock.select(nil)
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .opacity(0.7)
                        .padding(5)
                }
                .tint(.white)
            }
        }
        .padding(.horizontal)
    }
}

