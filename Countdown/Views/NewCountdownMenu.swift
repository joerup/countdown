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
    
    @State private var showEditor: Bool = false
    
    @State private var name: String = ""
    @State private var displayName: String = ""
    @State private var occasion: Occasion = .now
    @State private var type: EventType = .custom
    
    @State private var navigationPath: [Destination] = []
    
    var onCreate: (Countdown) -> Void
    
    private var holidays: [Holiday] {
        Array(Holiday.all.sorted(by: { $0.occasion.date < $1.occasion.date }))
    }
    
    init(onCreate: @escaping (Countdown) -> Void) {
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
            .sheet(isPresented: $showEditor) {
                CountdownEditor(name: name, displayName: displayName, type: type, occasion: occasion) { countdown in
                    dismiss()
                    onCreate(countdown)
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
                    selectHoliday(holiday)
                }
                .navigationTitle("All Holidays")
            }
        }
    }
    
    private func selectCustomEvent() {
        type = .custom
        name = ""
        displayName = ""
        occasion = .now
        showEditor.toggle()
    }
    
    private func selectHoliday(_ holiday: Holiday) {
        type = .holiday
        name = holiday.name
        displayName = holiday.displayName
        occasion = holiday.occasion
        showEditor.toggle()
    }
}
