//
//  HolidayEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/4/23.
//

import SwiftUI
import CountdownData

struct HolidayEditor: View {
    
    typealias Holiday = Countdown.Holiday
    
    @Binding var name: String
    @Binding var destination: Countdown.Destination?
    
    @State private var holiday: Holiday? = nil
    
    @State private var search: String = ""
    
    var sortedHolidays: [Holiday] {
        Holiday.all.sorted { $0.date.next < $1.date.next }
    }
    var filteredHolidays: [Holiday] {
        sortedHolidays.filter { $0.name.lowercased().contains(search.lowercased()) }
    }
    
    var body: some View {
        List {
            ForEach(search == "" ? sortedHolidays : filteredHolidays, id: \.self) { holiday in
                Button {
                    withAnimation {
                        self.holiday = holiday
                    }
                } label: {
                    HStack {
                        Text(holiday.name)
                            .font(.system(.headline, weight: .medium))
                            .foregroundStyle(self.holiday == holiday ? .pink : .primary)
                        Spacer()
                        Text(holiday.date.next.string)
                            .font(.system(.headline, weight: .medium))
                            .foregroundStyle(self.holiday == holiday ? .gray : .gray)
                        if self.holiday == holiday {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.pink)
                        }
                    }
                }
            }
        }
        .searchable(text: $search, prompt: "Search for holidays")
        .onAppear {
            if let destination, case .holiday(let name) = destination, let holiday = Holiday(named: name) {
                self.holiday = holiday
            }
        }
        .onChange(of: holiday) { _, holiday in
            if let holiday {
                self.name = holiday.displayName
                self.destination = .holiday(name: holiday.name)
            }
        }
    }
    
    private func holidayDetails(for holiday: Holiday) -> some View {
        List {
            Text(holiday.name)
            Section {
                TextField("Display Name", text: $name)
            }
        }
        .onAppear {
        }
    }
}
