//
//  NewCountdownMenu.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/22/24.
//

import SwiftUI
import CountdownData

struct NewCountdownMenu: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(Clock.self) var clock
    
    @State private var newCountdown: ProtoCountdown?
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var occasion: Occasion = .now
    @State private var type: EventType = .custom
    
    @State private var navigationPath: [Destination] = []
    
    private var holidays: [Holiday] {
        Array(Holiday.all.sorted(by: { $0.occasion.date < $1.occasion.date }))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section {
                    Button {
                        newCountdown = ProtoCountdown(type: .custom, name: "", displayName: "", occasion: .now)
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
                        newCountdown = ProtoCountdown(type: .holiday, name: holiday.name, displayName: holiday.displayName, occasion: holiday.occasion)
                    }
                }
            }
            .navigationTitle("New Countdown")
            .toolbarTitleDisplayMode(.inline)
            .navigationDestination(for: Destination.self) { destination in
                destinationPage(for: destination)
            }
            .sheet(item: $newCountdown) { countdown in
                CountdownEditor(name: countdown.name, displayName: countdown.displayName, type: countdown.type, occasion: countdown.occasion) { countdown in
                    dismiss()
                    clock.select(countdown)
                }
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
        case allHolidaysList
    }
    
    private func destinationPage(for destination: Destination) -> some View {
        Group {
            switch destination {
            case .allHolidaysList:
                HolidayList { holiday in
                    newCountdown = ProtoCountdown(type: .holiday, name: holiday.name, displayName: holiday.displayName, occasion: holiday.occasion)
                }
                .navigationTitle("All Holidays")
            }
        }
    }
    
    private struct ProtoCountdown: Identifiable {
        let id = UUID()
        var type: EventType
        var name: String
        var displayName: String
        var occasion: Occasion
    }
}
