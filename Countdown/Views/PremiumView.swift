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
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var premium: Premium
    
    @State private var products: [Product] = []
    
    var body: some View {
        Group {
            if let product = products.first {
                VStack(spacing: 25) {
                    VStack {
                        Image("Countdown Icon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                            .padding()
                        Text("Countdown")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        Text("Premium")
                            .textCase(.uppercase)
                            .font(.system(.largeTitle, weight: .bold))
                            .fontWidth(.expanded)
                    }
                    .foregroundStyle(.white)
                    Text("Upgrade to Premium to create an unlimited number of countdowns!")
                        .font(.system(.title3, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .frame(maxWidth: 400)
                        .padding(.horizontal)
                    Spacer()
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
                                .fill(Color(red: 237/255, green: 45/255, blue: 57/255))
                            if !premium.isActive {
                                VStack {
                                    Text("Purchase for \(product.displayPrice)")
                                        .font(.system(.title2, design: .rounded, weight: .bold))
                                        .foregroundStyle(.white)
                                    Text("One-time charge")
                                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                            } else {
                                HStack {
                                    Text("Unlocked")
                                    Image(systemName: "checkmark")
                                }
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: 500, maxHeight: 100)
                        .shadow(radius: 10)
                    }
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
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(red: 163/255, green: 55/255, blue: 68/255))
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

