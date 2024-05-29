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
        
        do {
            countdowns = try sharedModelContainer.mainContext.fetch(FetchDescriptor<Countdown>())
        } catch {
            print(error)
        }
        
        // Start the clock
        Task {
            await clock.start(countdowns: countdowns)
        }
        
//        // Get the countdown
//        if presentationStyle == .transcript {
//            insertView {
//                Group {
//                    if let countdown = selectedCountdown {
//                        CountdownSquare(countdown: countdown)
//                    } else {
//                        Text("\(activeConversation == nil)")
//                    }
//                }
//            }
//        }
//        
//        else {
            insertView(CountdownView(countdowns: countdowns))
//        }
    }
    
    override func contentSizeThatFits(_ size: CGSize) -> CGSize {
        if presentationStyle == .transcript {
            return CGSize(width: min(200, size.width), height: min(200, size.height))
        }
        return size
    }
    
    
    // MARK: - Message Handling
    
    func createMessage(for countdown: Countdown) {
        let message = MSMessage()
        
        // Create the alternative layout (only used for devices without the app installed)
        let alternateLayout = MSMessageTemplateLayout()
        alternateLayout.caption = countdown.displayName
        alternateLayout.trailingCaption = "\(clock.daysRemaining(for: countdown))"
        alternateLayout.subcaption = countdown.dateString
        if case .photo(let photo) = countdown.currentBackground, let image = photo.square() {
            alternateLayout.image = image
        }
        
        // Create the live layout
        let layout = alternateLayout
//        let layout = MSMessageLiveLayout(alternateLayout: alternateLayout)
        
        message.layout = layout
        
        // Insert the message to the conversation
        if let conversation = activeConversation {
//            print("inserting into conversation \(conversation) message \(message) with summary \(message.summaryText) and with url \(message.url)")
            conversation.insert(message)
        }
        
//        // Create the URL
//        if let url = countdown.createURL() {
//            let summary = "Hello there"
//            
//            print("url has been set for \(message)")
//            message.url = url
//            print("url is \(url)")
//            print("url is \(message.url)")
//            message.summaryText = summary
//            print("summary is \(summary)")
//            print("summary is \(message.summaryText)")
////            message.summaryText = countdown.displayName
//        }
        
        // Make presentation compact
        requestPresentationStyle(.compact)
    }
    
    
    // MARK: - Lifecycle Methods
    
//    override func willBecomeActive(with conversation: MSConversation) {
//        super.willBecomeActive(with: conversation)
//        
//        guard presentationStyle == .transcript else { return }
//        
//        print("did become active with \(conversation)")
//        print("the message is \(conversation.selectedMessage)")
//        print("the message summary is \(conversation.selectedMessage?.summaryText)")
//        print("the message url is \(conversation.selectedMessage?.url)")
//    }
    
//    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
//        super.didSelect(message, conversation: conversation)
//            
//        print("accessing message \(message.summaryText) via \(presentationStyle.rawValue)")
//        
//        guard let url = message.url,
//              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//              components.host == "countdown",
//              let queryItem = components.queryItems?.first(where: { $0.name == "data" }),
//              let dataString = queryItem.value,
//              let data = Data(base64Encoded: dataString),
//              let countdown = try? JSONDecoder().decode(Countdown.self, from: data)
//        else {
//            return
//        }
//    }

    
    
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

