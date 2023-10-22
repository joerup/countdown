//
//  OccasionEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/20/23.
//

import SwiftUI
import CountdownData

struct OccasionEditor: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var clock: Clock
    
    var countdown: Countdown?
    var type: EventType
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var occasion: Occasion?
    
    var onCreate: (Countdown) -> Void
    
    init(countdown: Countdown) {
        self.countdown = countdown
        self.type = countdown.type
        self.onCreate = { _ in }
        self._name = State(initialValue: countdown.name)
        self._displayName = State(initialValue: countdown.displayName)
        self._occasion = State(initialValue: countdown.occasion)
    }
    init(type: EventType, onCreate: @escaping (Countdown) -> Void) {
        self.countdown = nil
        self.type = type
        self.onCreate = onCreate
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
                        .disabled(occasion == nil || name.isEmpty)
                    }
                }
        }
        .tint(.pink)
    }
    
    @ViewBuilder
    private var page: some View {
        switch type {
        case .holiday:
            HolidayEditor(name: $name, displayName: $displayName, occasion: $occasion)
        case .custom:
            DateEditor(name: $name, displayName: $displayName, occasion: $occasion)
        }
    }
    
    private func saveCountdown() {
        guard let occasion else { return }
        if let countdown {
            countdown.name = name
            countdown.displayName = displayName
            countdown.type = type
            countdown.occasion = occasion
            clock.scheduleNotification(for: countdown)
        } else {
            let countdown = Countdown(name: name, displayName: displayName, type: type, occasion: occasion)
            clock.scheduleNotification(for: countdown)
            modelContext.insert(countdown)
            onCreate(countdown)
        }
    }
}

