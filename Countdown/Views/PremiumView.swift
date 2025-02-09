//
//  PremiumView.swift
//  Countdown
//
//  Created by Joe Rupertus on 10/28/23.
//

import SwiftUI
import StoreKit
import CountdownData

struct PremiumView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(Premium.self) private var premium
    
    @State private var products: [Product] = []
    @State private var animateText = false
    @State private var animateButton = false
    @State private var animateUnlimited = false
    
    private let titleGradient = LinearGradient(
        colors: [Color.white.opacity(0.9), Color.init(white: 0.9).opacity(0.9)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    private let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.6, green: 0.2, blue: 0.25), Color(red: 0.7, green: 0.3, blue: 0.35)],
        startPoint: .bottom,
        endPoint: .top
    )
    
    private let buttonGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.4, blue: 0.4), Color(red: 0.9, green: 0.2, blue: 0.3)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        Group {
            if let product = products.first {
                VStack(spacing: 25) {
                    
                    // Top Section with Gradient Title
                    HStack {
                        Image("icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 10)
                            .padding(.horizontal, 5)
                        Text("Premium")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(titleGradient)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundStyle(.white)
                    .padding(.top)
                    
                    // Styled Description with Enhanced "Unlimited"
                    HStack {
                        Text("Create")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.7))
                        Text("unlimited")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .scaleEffect(animateUnlimited ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateUnlimited)
                        Text("countdowns.")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Placeholder for future image
                    Image("splash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .shadow(radius: 10)
                    
                    Spacer()
                    
                    // Animated Purchase Button
                    Button {
                        Task {
                            guard !premium.isActive else { dismiss(); return }
                            if await premium.purchase(product) {
                                dismiss()
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(buttonGradient)
                                .scaleEffect(animateButton ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateButton)
                            
                            if !premium.isActive {
                                VStack {
                                    Text("Purchase for \(product.displayPrice)")
                                        .font(.system(.title2, design: .rounded, weight: .bold))
                                        .foregroundStyle(.white)
                                    Text("One-time charge")
                                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                .scaleEffect(animateButton ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateButton)
                            } else {
                                HStack {
                                    Text("Unlocked")
                                    Image(systemName: "checkmark")
                                }
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                                .scaleEffect(animateButton ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateButton)
                            }
                        }
                        .frame(maxWidth: 500, maxHeight: 100)
                        .shadow(radius: 10)
                    }
                    .onAppear {
                        animateButton = true
                        animateUnlimited = true
                    }
                    
                    // Restore Purchase Button
                    Button {
                        Task {
                            await premium.restore(product)
                        }
                    } label: {
                        Text("Restore Purchase")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 10)
                }
                .padding()
                .onAppear {
                    animateText = true
                }
                .animation(.easeInOut(duration: 0.5), value: products)
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundGradient)
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.white.opacity(0.5))
                    .padding()
            }
        }
        .task {
            products = await premium.retrieveProducts()
        }
    }
}
