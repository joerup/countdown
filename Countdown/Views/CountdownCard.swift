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
    
    @Binding var editCard: Bool
    
    @State private var editDestination = false
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
        VStack {
            if editCard {
                CountdownSquare(countdown: countdown)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: squareSize)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                Spacer(minLength: 0)
            } else {
                CountdownFullLayout(countdown: countdown)
                    .padding([.horizontal, .bottom])
            }
            Button {
                withAnimation {
                    self.editCard.toggle()
                }
            } label: {
                Text("Edit")
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 30).fill(Material.ultraThin))
            }
//            VStack(spacing: 10) {
//                TimeDisplay(timeRemaining: countdown.timeRemaining, tintColor: countdown.currentTintColor, textStyle: countdown.currentTextStyle, textWeight: Font.Weight(rawValue: countdown.currentTextWeight), textOpacity: 1.0, textSize: 37.5)
//                Text(countdown.date.fullString)
//                    .font(.title3)
//                    .fontWidth(.condensed)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.white)
//                    .opacity(0.9)
//            }
//            .padding()
//            .background(Material.ultraThin.opacity(0.5))
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            Spacer(minLength: 0)
        }
        .padding(.bottom, 50)
        .padding(.top, (editCard ? 10 : 50) + topPadding)
        .padding(20)
        .frame(width: size.width, height: size.height)
        .overlay {
            if editCard, let card = countdown.card {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.white.opacity(1e-6))
                        .onTapGesture {
                            withAnimation {
                                editCard = false
                            }
                        }
                    CardEditor(card: card, edgeInsets: fullScreen ? edgeInsets : .init()) {
                        withAnimation {
                            editCard = false
                        }
                    }
                    .frame(maxHeight: size.height + (fullScreen ? edgeInsets.bottom : 0) - topPadding - squareSize - 65)
                    .background(Material.ultraThin)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .transition(.move(edge: .bottom))
                .ignoresSafeArea(edges: .vertical)
            }
        }
        .background {
            BackgroundDisplay(background: countdown.currentBackground, color: countdown.currentBackgroundColor, fade: countdown.currentBackgroundFade, blur: countdown.currentBackgroundBlur, brightness: countdown.currentBackgroundBrightness, saturation: countdown.currentBackgroundSaturation, contrast: countdown.currentBackgroundContrast, fullScreen: true)
                .overlay(Material.ultraThin.opacity(editCard ? 1 : 0))
                .frame(width: totalWidth, height: totalHeight)
                .clipShape(RoundedRectangle(cornerRadius: fullScreen ? 0 : 40))
                .clipped()
                .ignoresSafeArea(edges: .vertical)
                .id(clock.tick)
        }
        .overlay(alignment: .top) {
            if !editCard {
                header
                    .padding(.top, topPadding)
            }
        }
        .sheet(isPresented: $editDestination) {
            if let countdown = clock.selectedCountdown {
                OccasionEditor(countdown: countdown)
                    .presentationBackground(Material.thin)
            }
        }
        .sheet(isPresented: $shareCountdown) {
            if let countdown = clock.selectedCountdown {
                ShareMenu(countdown: countdown)
                    .presentationBackground(Material.thin)
            }
        }
        .alert("Delete Countdown", isPresented: $deleteCountdown) {
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
        HStack {
            Button {
                editDestination.toggle()
            } label: {
                Image(systemName: "calendar")
                    .opacity(0.5)
                    .padding(5)
            }
            .tint(.white)
            
            Button {
                deleteCountdown.toggle()
            } label: {
                Image(systemName: "trash")
                    .opacity(0.5)
                    .padding(5)
            }
            .tint(.white)
            
            Spacer()
            
            Button {
                withAnimation {
                    clock.select(nil)
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .opacity(0.5)
                    .padding(5)
            }
            .tint(.white)
        }
//        .overlay {
//            Text(countdown.displayName)
//                .fontWeight(.bold)
//                .foregroundStyle(.white)
//                .opacity(0.8)
//        }
        .padding(.horizontal)
    }
}

