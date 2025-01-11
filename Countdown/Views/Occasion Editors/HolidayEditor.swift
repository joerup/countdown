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
    @Binding var occasion: Occasion
    
    @State private var showMoreDates: Bool = false
    
    @State private var editDate: Bool = false
    
    var body: some View {
        Group {
            Section("Event") {
                TextField("Event Name", text: $displayName)
            }
            Section("Occurs") {
                Button {
                    editDate.toggle()
                } label: {
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundStyle(.secondary)
                        Text("\(occasion.string)")
                    }
                    .foregroundStyle(.foreground)
                }
                .popover(isPresented: $editDate) {
                    banner
                        .padding()
                        .presentationCompactAdaptation(.popover)
                        .presentationBackground(Color.blue.opacity(0.1))
                        .presentationCornerRadius(30)
                }
            }
//                    Section("Upcoming Dates") {
//                        ForEach(occasion.futureDates(showMoreDates ? 10 : 3), id: \.self) { date in
//                            Text(date.fullDateString)
//                                .foregroundStyle(.secondary)
//                        }
//                        Button("Show \(showMoreDates ? "Less" : "More")") {
//                            showMoreDates.toggle()
//                        }
//                    }
        }
    }
    
    private var banner: some View {
        HStack {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundColor(.blue)
            Text("This countdown is automatically set to the next date of \(name).")
                .fixedSize(horizontal: false, vertical: true)
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
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
                .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    @Previewable @State var name: String = "Christmas"
    @Previewable @State var displayName: String = "Christmas"
    @Previewable @State var occasion: Occasion = .annualDate(calendar: "gregorian", month: 12, day: 25)
    
    List {
        HolidayDetails(
            name: $name,
            displayName: $displayName,
            occasion: $occasion
        )
    }
}
