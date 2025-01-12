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
    
    private var topPadding: CGFloat {
        fullScreen ? 0 : 15
    }
    private var totalWidth: CGFloat {
        size.width + (fullScreen ? (edgeInsets.leading + edgeInsets.trailing) : 0)
    }
    private var totalHeight: CGFloat {
        size.height + (fullScreen ? (edgeInsets.bottom + edgeInsets.top) : 0)
    }
    private var widthOffset: CGFloat {
        fullScreen ? (edgeInsets.trailing - edgeInsets.leading) : 0
    }
    private var heightOffset: CGFloat {
        fullScreen ? (edgeInsets.top - edgeInsets.bottom) : 0
    }
    
    public var body: some View {
        CountdownFullLayout(countdown: countdown)
            .padding([.horizontal, .bottom])
            .padding(.vertical, 40)
            .padding(.top, topPadding)
            .padding(20)
            .frame(width: size.width, height: size.height)
            .sheet(isPresented: $editCountdown) {
                CountdownEditor(countdown: countdown) { _ in }
            }
            .background {
                BackgroundDisplay(background: countdown.currentBackground?.full, color: countdown.currentBackgroundColor, fade: countdown.currentBackgroundFade, blur: countdown.currentBackgroundBlur, dim: countdown.currentBackgroundDim, brightness: countdown.currentBackgroundBrightness, saturation: countdown.currentBackgroundSaturation, contrast: countdown.currentBackgroundContrast)
                    .overlay(alignment: .bottom) {
                        if countdown.currentBackground != nil {
                            LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
                                .frame(height: size.height/3)
                        }
                    }
                    .frame(width: totalWidth, height: totalHeight)
                    .clipShape(RoundedRectangle(cornerRadius: editCountdown && fullScreen ? 0 : 40))
                    .clipped()
                    .padding(.leading, widthOffset)
                    .padding(.bottom, heightOffset)
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
    }
    
    private var header: some View {
        HStack(spacing: 15) {
            
            if fullScreen && !editCountdown {
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

