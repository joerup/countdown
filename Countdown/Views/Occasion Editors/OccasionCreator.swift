//
//  NewCountdown.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/22/24.
//

import SwiftUI
import CountdownData

struct OccasionCreator: View {
    
    @Environment(Clock.self) private var clock
    
    @Environment(\.dismiss) var dismiss
    
    var countdown: Countdown?
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var occasion: Occasion?
    @State private var type: EventType? = nil
    
    @State private var navigationPath: [Destination] = []
    
    var onCreate: (Countdown) -> Void
    
    private var holidays: [Holiday] {
        Array(Holiday.all.sorted(by: { $0.occasion.date < $1.occasion.date }))
    }
    
    init(onCreate: @escaping (Countdown) -> Void) {
        self.countdown = nil
        self.onCreate = onCreate
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section {
                    Button {
                        selectCustomEvent()
                    } label: {
                        HStack {
                            Text("Custom Event")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                Section("Holidays") {
                    Holidays(holidays: holidays) { holiday in
                        selectHoliday(holiday)
                    }
                }
            }
            .navigationTitle("New Countdown")
            .toolbarTitleDisplayMode(.inline)
            .navigationDestination(for: Destination.self) { destination in
                destinationPage(for: destination)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .tint(.pink)
    }
    
    private enum Destination: Hashable {
        case addCustomEvent
        case addHoliday
        case allHolidaysList
    }
    
    private func destinationPage(for destination: Destination) -> some View {
        Group {
            switch destination {
            case .addCustomEvent:
                DateEditor(name: $name, displayName: $displayName, occasion: $occasion)
            case .addHoliday:
                HolidayDetails(name: $name, displayName: $displayName, occasion: $occasion)
            case .allHolidaysList:
                HolidayList { holiday in
                    selectHoliday(holiday)
                }
                .navigationTitle("All Holidays")
            }
        }
        .toolbar {
            switch destination {
            case .addCustomEvent, .addHoliday:
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        saveCountdown()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(type == .custom && (occasion == nil || name.isEmpty))
                }
            default:
                ToolbarItem(placement: .topBarTrailing) {
                    EmptyView()
                }
            }
        }
        .toolbarTitleDisplayMode(.inline)
    }
    
    private func selectCustomEvent() {
        type = .custom
        name = ""
        displayName = ""
        occasion = nil
        navigationPath.append(.addCustomEvent)
    }
    
    private func selectHoliday(_ holiday: Holiday) {
        type = .holiday
        name = holiday.name
        displayName = holiday.displayName
        occasion = holiday.occasion
        navigationPath.append(.addHoliday)
    }
    
    private func saveCountdown() {
        guard let occasion, let type else { return }
        let countdown = Countdown(name: name, displayName: displayName, type: type, occasion: occasion)
        clock.add(countdown)
        onCreate(countdown)
    }
}
