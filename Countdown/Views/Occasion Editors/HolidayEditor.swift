//
//  HolidayEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/4/23.
//

import SwiftUI
import CountdownData

struct HolidayEditor: View {
    
    @Binding var name: String
    @Binding var displayName: String
    @Binding var occasion: Occasion?
    
    @State private var holiday: Holiday? = nil
    
    @State private var search: String = ""
    
    var sortedHolidays: [Holiday] {
        Holiday.all.sorted { $0.occasion.date < $1.occasion.date }
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
                        Text(holiday.occasion.date.dateString)
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
            self.holiday = Holiday.get(name)
        }
        .onChange(of: holiday) { _, holiday in
            if let holiday {
                self.name = holiday.name
                self.displayName = holiday.displayName
                self.occasion = holiday.occasion
            }
        }
    }
}
