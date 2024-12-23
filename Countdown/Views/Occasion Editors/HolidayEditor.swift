//
//  HolidayEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 8/4/23.
//

import SwiftUI
import CountdownData

struct HolidayDetails: View {
    
    @Binding var name: String
    @Binding var displayName: String
    @Binding var occasion: Occasion?
    
    var body: some View {
        List {
            Section("Holiday") {
                Text(name)
            }
            if let occasion {
                Section("Occurs") {
                    Text(occasion.string)
                }
                Section(
                    header: Text("Upcoming Dates"),
                    footer: Text("This countdown will roll over to the next year automatically.")
                ){
                    ForEach(Array(occasion.futureDates(10).enumerated()), id: \.element) { index, date in
                        Text(date.fullDateString)
                            .foregroundStyle(index == 0 ? .primary : .secondary)
                    }
                }
            }
        }
    }
}

struct HolidayList: View {
    
    @State private var search: String = ""
    
    private var sortedHolidays: [Holiday] {
        Holiday.all.sorted { $0.occasion.date < $1.occasion.date }
    }
    private var filteredHolidays: [Holiday] {
        sortedHolidays.filter { $0.name.lowercased().starts(with: search.lowercased()) } + sortedHolidays.filter { $0.name.lowercased().contains(search.lowercased()) && !$0.name.lowercased().starts(with: search.lowercased()) }
    }
    private var holidays: [Holiday] {
        search != "" ? filteredHolidays : sortedHolidays
    }
    
    var action: (Holiday) -> Void
    
    var body: some View {
        List {
            Holidays(holidays: holidays) { holiday in
                action(holiday)
            }
        }
        .searchable(text: $search, placement: .navigationBarDrawer, prompt: "Search for holidays")
    }
}

struct Holidays: View {
    
    var holidays: [Holiday]
    
    var action: (Holiday) -> Void
    
    var body: some View {
        ForEach(holidays, id: \.self) { holiday in
            Button {
                action(holiday)
            } label: {
                HStack {
                    Text(holiday.name)
                    Spacer()
                    Text(holiday.occasion.date.dateString)
                        .foregroundStyle(.gray)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .foregroundColor(.primary)
            }
        }
    }
}
