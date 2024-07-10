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
    
    private var countdowns: [Countdown] = []
    
    private var context: ModelContext {
        sharedModelContainer.mainContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch the countdowns
        do {
            countdowns = try context.fetch(FetchDescriptor<Countdown>())
        } catch {
            print(error)
        }
        
        // Perform initial update
        update()
    }
    
    private func update(instance: CountdownInstance? = nil, sent: Bool? = nil) {
        if presentationStyle == .transcript {
            guard let instance, let sent else { return }
            let existingCountdown = countdowns.first(where: { $0.id == instance.countdownID })
            
            Task {
                insertView(CountdownBubble(instance: instance, existingCountdown: existingCountdown, sent: sent, update: update(instance:sent:), append: { self.countdowns.append($0) }))
                
                if let existingCountdown, instance.compareTo(countdown: existingCountdown) {
                    await existingCountdown.loadCards()
                } else {
                    await instance.loadCard()
                }
                
                insertView(CountdownBubble(instance: instance, existingCountdown: existingCountdown, sent: sent, update: update(instance:sent:), append: { self.countdowns.append($0) }))
            }
        }
        else {
            Task {
                for countdown in countdowns {
                    await countdown.loadCards()
                }
                
                insertView(CountdownGrid(countdowns: countdowns))
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
        if case .photo(let photo) = countdown.currentBackground, let image = photo.square() {
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
        if let image, let photoData = image.compressed(size: Card.maxPhotoSize) {
            instance.setBackground(.photo(photoData))
        }
        
        // Update the message bubble
        update(instance: instance, sent: true)//conversation.localParticipantIdentifier == message.senderParticipantIdentifier)
    }

    
    // MARK: Insert SwiftUI View
    
    private func insertView(_ newView: some View) {
        let swiftUIView = newView
            .modelContainer(sharedModelContainer)
//            .environmentObject(clock)
            .environment(self)
        let swiftUIViewController = UIHostingController(rootView: swiftUIView)
        
        addChild(swiftUIViewController)
        view.addSubview(swiftUIViewController.view)
        swiftUIViewController.view.frame = view.bounds
        swiftUIViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        swiftUIViewController.didMove(toParent: self)
    }
}

