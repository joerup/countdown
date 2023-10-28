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
    
    var body: some View {
        StoreView(ids: premium.ids) { product in
            Image("Countdown Icon")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .foregroundStyle(.white)
        .buttonStyle(CustomButtonStyle())
        .storeButton(.visible, for: .restorePurchases)
        .storeButton(.visible, for: .redeemCode)
        .storeButton(.visible, for: .signIn)
        .background(Color.init(red: 163/255, green: 55/255, blue: 68/255))
        .presentationCornerRadius(20)
        .presentationDetents([.medium])
        .tint(.white)
        .onInAppPurchaseCompletion { _, result in
            await premium.update()
            dismiss()
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .background(Color(red: 237/255, green: 45/255, blue: 57/255))
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
