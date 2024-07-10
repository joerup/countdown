//
//  ShareMenu.swift
//  Countdown
//
//  Created by Joe Rupertus on 5/31/24.
//

import SwiftUI
import CountdownData
import Messages
import MessageUI

struct ShareMenu: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    var countdown: Countdown

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = context.coordinator
        
        // Create the message
        let message = MSMessage()
//        message.url = countdown.encodingURL()
        
        if let url = message.url {
            composeVC.addAttachmentURL(url, withAlternateFilename: "MyAttachment")
        } else {
            // Handle the error: the device can't send text messages
            print("This device cannot send text messages")
        }

        return composeVC
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: ShareMenu

        init(_ parent: ShareMenu) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

