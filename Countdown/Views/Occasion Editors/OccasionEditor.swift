//
//  OccasionEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 7/20/23.
//

import SwiftUI
import CountdownData

struct OccasionEditor: View {
    
    @Environment(Clock.self) private var clock
    
    @Environment(\.dismiss) var dismiss
    
    var countdown: Countdown
    var type: EventType
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var occasion: Occasion?
    
    init(countdown: Countdown) {
        self.countdown = countdown
        self.type = countdown.type
        self._name = State(initialValue: countdown.name)
        self._displayName = State(initialValue: countdown.displayName)
        self._occasion = State(initialValue: countdown.occasion)
    }
    
    var body: some View {
        NavigationStack {
            page
                .navigationTitle("Edit Countdown")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            saveCountdown()
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .disabled(type == .custom && (occasion == nil || name.isEmpty))
                    }
                }
        }
        .tint(.pink)
    }
    
    @ViewBuilder
    private var page: some View {
        switch type {
        case .holiday:
            HolidayDetails(name: $name, displayName: $displayName, occasion: $occasion)
        case .custom:
            DateEditor(name: $name, displayName: $displayName, occasion: $occasion)
        }
    }
    
    private func saveCountdown() {
        guard let occasion else { return }
        countdown.name = name
        countdown.displayName = displayName
        countdown.type = type
        countdown.occasion = occasion
        clock.edit(countdown)
    }
}

