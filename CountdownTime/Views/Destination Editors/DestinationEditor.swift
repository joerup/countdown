//
//  DestinationEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/20/23.
//

import SwiftUI
import CountdownData

struct DestinationEditor: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) var dismiss
    
    var countdown: Countdown?
    var type: Countdown.DestinationType
    
    @State private var name: String = ""
    @State private var destination: Countdown.Destination?
    
    init(countdown: Countdown) {
        self.countdown = countdown
        self.type = countdown.destination.type
        self._name = State(initialValue: countdown.name)
        self._destination = State(initialValue: countdown.destination)
    }
    init(type: Countdown.DestinationType) {
        self.countdown = nil
        self.type = type
    }
    
    var body: some View {
        NavigationStack {
            page
                .navigationTitle("\(countdown == nil ? "New" : "Edit") Countdown")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(countdown == nil ? "Add" : "Done") {
                            saveCountdown()
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .disabled(destination == nil)
                    }
                }
        }
        .tint(.pink)
    }
    
    private var page: some View {
        Group {
            switch type {
            case .holiday:
                HolidayEditor(name: $name, destination: $destination)
            case .birthday:
                BirthdayEditor(name: $name, destination: $destination)
            case .custom:
                DateEditor(name: $name, destination: $destination)
            }
        }
    }
    
    private func saveCountdown() {
        guard let destination else { return }
        if let countdown {
            countdown.name = name
            countdown.destination = destination
        } else {
            let countdown = Countdown(name: name, destination: destination)
            modelContext.insert(countdown)
        }
    }
}

