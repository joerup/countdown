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

class MessageController: MSMessagesAppViewController {
    
    private var clock = Clock(modelContext: sharedModelContainer.mainContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    private func update(instance: CountdownInstance? = nil, sent: Bool? = nil) {
        if presentationStyle == .transcript {
            guard let instance, let sent else { return }
            Task {
                let id = instance.countdownID
                await clock.loadStaticCountdownData(predicate: #Predicate { $0.id == id }, includeCards: false)
                let existingCountdown = clock.countdowns.first
                await instance.loadCard()
                insertView(CountdownBubble(instance: instance, existingCountdown: existingCountdown, sent: sent, update: update(instance:sent:), add: clock.add(_:), edit: clock.edit(_:)))
            }
        }
        else {
            Task {
                await clock.loadStaticCountdownData()
                insertView(CountdownGrid(countdowns: clock.countdowns, createMessage: createMessage(for:)))
            }
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
        alternateLayout.trailingCaption = "\(countdown.date.daysRemaining()) days"
        alternateLayout.subcaption = countdown.dateString
        if let image = countdown.currentBackground?.full {
            // this is a hacky way to send the image without encoding it in a URL
            alternateLayout.image = image
        }
        
        // Create the live layout
        let layout = MSMessageLiveLayout(alternateLayout: alternateLayout)
        message.layout = layout
        
        // Create a specific instance and URL to decode it
        let instance = CountdownInstance(from: countdown)
        if let url = instance.toEncodingURL() {
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
        
        // Decode the message and create an instance of a countdown
        guard let message = conversation.selectedMessage,
            let url = message.url,
            let instance = CountdownInstance.fromEncodingURL(url)
        else { return }
        
        // Use the alternateLayout image as a workaround to send image if represented as data, instead of sending it through URL
        let image: UIImage? =
        if let layout = message.layout as? MSMessageLiveLayout {
            layout.alternateLayout.image
        } else {
            nil
        }
        if let image, let photoData = image.jpegData(compressionQuality: 0.8) {
            instance.setBackground(photoData)
        }
        
        // Update the message bubble
        update(instance: instance, sent: conversation.localParticipantIdentifier == message.senderParticipantIdentifier)
    }

    
    // MARK: Insert SwiftUI View
    
    private func insertView(_ newView: some View) {
        let swiftUIView = newView.modelContainer(sharedModelContainer)
        let swiftUIViewController = UIHostingController(rootView: swiftUIView)
        addChild(swiftUIViewController)
        view.addSubview(swiftUIViewController.view)
        swiftUIViewController.view.frame = view.bounds
        swiftUIViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        swiftUIViewController.didMove(toParent: self)
    }
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Countdown.self, Card.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
