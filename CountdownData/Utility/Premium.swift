//
//  Premium.swift
//
//
//  Created by Joe Rupertus on 10/28/23.
//

import Foundation
import StoreKit

public class Premium: ObservableObject {
    
    public let ids = ["com.rupertusapps.Countdown.Premium"]

    @Published private(set) var purchasedProductIDs = Set<String>()

    public var isActive: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    public init() { }

    @MainActor
    public func update() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                print("No premium active")
                continue
            }
            print("Premium active")

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
}
