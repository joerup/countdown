//
//  CalendarEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/7/23.
//

import SwiftUI
import CountdownData
import EventKit

struct CalendarEditor: View {
    
    @Binding var name: String
    @Binding var destination: Countdown.Destination?
    
    @State private var events: [EKEvent] = []
    @State private var selectedEvent: EKEvent? = nil
    
    var body: some View {
        List {
            Section {
                if events.isEmpty {
                    Text("No Events")
                }
                ForEach(events, id: \.self) { event in
                    Button {
                        self.selectedEvent = event
                    } label: {
                        Text(event.title ?? "")
                    }
                }
            }
        }
        .onAppear {
            self.events = EKEvent.getAllEvents()
        }
//        .onChange(of: selectedEvent) { _, event in
//            if let event, let name = event.title, let eventID = event.eventIdentifier {
//                self.name = name
//                self.destination = .calendar(event: eventID)
//            }
//        }
    }
}
