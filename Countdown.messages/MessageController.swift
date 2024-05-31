//
//  MessageController.swift
//  Countdown.messages
//
//  Created by Joe Rupertus on 5/28/24.
//

import UIKit
import SwiftUI
import Messages
import SwiftData
import CountdownData
import CountdownUI

class MessageController: MSMessagesAppViewController, Observable {
    
    private var clock = Clock()
    
    private var countdowns: [Countdown] = []
    private var selectedCountdown: Countdown?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch the countdowns
        do {
            countdowns = try sharedModelContainer.mainContext.fetch(FetchDescriptor<Countdown>())
        } catch {
            print(error)
        }
        
        // Start the clock
        Task {
            if !clock.isLoaded {
                await clock.start(countdowns: countdowns)
            }
        }
        
        // Set the view
        setView()
    }
    
    private func setView() {
        if presentationStyle == .transcript {
            insertView(CountdownBubble(selectedCountdown: selectedCountdown))
        } else {
            insertView(CountdownGrid(countdowns: countdowns.filter(\.isSaved)))
        }
    }
    
    override func contentSizeThatFits(_ size: CGSize) -> CGSize {
        if presentationStyle == .transcript {
            return CGSize(width: min(200, size.width), height: min(200, size.height))
        }
        return size
    }
    
    
    // MARK: - Message Handling
    
    func createMessage(for countdown: Countdown) {
        let message = MSMessage(session: MSSession())
        
        // Create the alternative layout (only used for devices without the app installed)
        let alternateLayout = MSMessageTemplateLayout()
        alternateLayout.caption = countdown.displayName
        alternateLayout.trailingCaption = "\(clock.daysRemaining(for: countdown))"
        alternateLayout.subcaption = countdown.dateString
        if case .photo(let photo) = countdown.currentBackground, let image = photo.square() {
            alternateLayout.image = image
        }
        
        // Create the live layout
        let layout = MSMessageLiveLayout(alternateLayout: alternateLayout)
        message.layout = layout
        
        // Set the URL which encodes the countdown data
        if let url = countdown.encodingURL() {
            message.url = url
        }
        
        // Insert the message to the conversation
        if let conversation = activeConversation {
            conversation.insert(message)
        }
        
        // Make presentation compact
        requestPresentationStyle(.compact)
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        super.didBecomeActive(with: conversation)
        
        guard presentationStyle == .transcript, let url = conversation.selectedMessage?.url else { return }
        
        // Use the alternateLayout image as a workaround to send image if represented as data, instead of sending it through URL
        let image: UIImage? =
        if let layout = conversation.selectedMessage?.layout as? MSMessageLiveLayout {
            layout.alternateLayout.image
        } else {
            nil
        }
        
        // Decode the countdown from the URL
        selectedCountdown = Countdown.fromEncodingURL(url, modelContext: sharedModelContainer.mainContext, countdowns: countdowns, image: image)
        
        // Set the view
        setView()
    }

    
    // MARK: Insert SwiftUI View
    
    private func insertView(_ newView: some View) {
        let swiftUIView = newView
            .modelContainer(sharedModelContainer)
            .environmentObject(clock)
            .environment(self)
        let swiftUIViewController = UIHostingController(rootView: swiftUIView)
        
        addChild(swiftUIViewController)
        view.addSubview(swiftUIViewController.view)
        swiftUIViewController.view.frame = view.bounds
        swiftUIViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        swiftUIViewController.didMove(toParent: self)
    }
}

