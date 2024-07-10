//
//  Countdown+URL.swift
//
//
//  Created by Joe Rupertus on 5/29/24.
//

import Foundation
import SwiftData
import UIKit

extension Countdown {
    
    // Create a link to open this countdown via id
    public func linkURL() -> URL? {
        var components = URLComponents()
        components.scheme = "countdown"
        components.host = "open"
        components.queryItems = [URLQueryItem(name: "id", value: id.uuidString)]
        
        return components.url
    }
    
//    // Create an encoding of this countdown which includes all of its data
//    public func encodingURL() -> URL? {
//        guard let countdownData = try? JSONEncoder().encode(self) else { return nil }
//        let countdownString = countdownData.base64EncodedString()
//        guard var components = URLComponents(string:"data:,") else { return nil }
//        components.queryItems = [URLQueryItem(name: "raw", value: countdownString)]
//        
//        return components.url
//    }
    
    // Open a URL requesting a specific countdown
    public static func fromLinkURL(_ url: URL, countdowns: [Countdown]) -> Countdown? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.scheme == "countdown",
              components.host == "open",
              let queryItems = components.queryItems,
              let idItem = queryItems.first(where: { $0.name == "id" }),
              let idString = idItem.value,
              let id = UUID(uuidString: idString)
        else {
            return nil
        }
        
        // Find and return the countdown
        return countdowns.first(where: { $0.id == id })
    }
    
//    // Decode the countdown from a message
//    // The countdown may already be stored or it may need to be created
//    public static func fromEncodingURL(_ url: URL, modelContext: ModelContext, countdowns: [Countdown], image: UIImage? = nil) -> Countdown? {
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
//              let queryItems = components.queryItems,
//              let rawItem = queryItems.first,
//              let base64String = rawItem.value,
//              let countdownData = Data(base64Encoded: base64String)
//        else {
//            return nil
//        }
//        
//        // Find the countdown in the data store and return it
//        if let json = try? JSONSerialization.jsonObject(with: countdownData, options: []) as? [String: Any],
//           let string = json["id"] as? String, let id = UUID(uuidString: string),
//           let countdown = countdowns.first(where: { $0.id == id })
//        {
//            return countdown
//        }
//        
//        // Otherwise, create a new countdown and insert it to the data store
//        // NOTE: The countdown will be "unsaved" meaning it will not be displayed until it is opened via `fromURL` above
//        // From the user's perspective, it only exists within the message transcript, until it is pressed and added
//        else if let countdown = try? JSONDecoder().decode(Countdown.self, from: countdownData) {
//            modelContext.insert(countdown)
//            countdown.isSaved = false
//            
//            // Set the background if it was transferred via workaround method (see MessageController)
//            if let card = countdown.card, card.backgroundData == nil, let data = image?.pngData() {
//                card.setBackground(.photo(data))
//            }
//            
//            return countdown
//        }
//        
//        return nil
//    }
}
