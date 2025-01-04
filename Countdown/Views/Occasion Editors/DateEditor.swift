//
//  DateEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 8/1/23.
//

import SwiftUI
import CountdownData

struct DateEditor: View {
    
    @Binding var name: String
    @Binding var displayName: String
    @Binding var occasion: Occasion
    
    @State private var date: Date = .now.midnight
    @State private var time: Date = .now.midnight
    
    @State private var includeTime: Bool = false
    @State private var repeatAnnually: Bool = false
    
    @State private var editDate: Bool = false
    
    var body: some View {
        Group {
            Section("Event") {
                TextField("Event", text: $name)
            }
            Section("Occurs") {
                Button {
                    editDate.toggle()
                } label: {
                    HStack {
                        if occasion.repeatAnnually {
                            Image(systemName: "repeat")
                        }
                        Text(occasion.string)
                    }
                }
                if editDate {
                    Toggle("Repeat Annually", isOn: $repeatAnnually)
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.wheel)
                    Toggle("Include Time", isOn: $includeTime)
                    if includeTime {
                        DatePicker("Time", selection: $time, displayedComponents: [.hourAndMinute])
                    }
                }
            }
        }
        .onAppear {
            self.date = occasion.date
            self.time = occasion.date
            self.includeTime = occasion.includeTime
            self.repeatAnnually = occasion.repeatAnnually
        }
        .onChange(of: name) { _, name in
            self.displayName = name
        }
        .onChange(of: date) { _, date in
            setDate(date: date, time: time)
        }
        .onChange(of: time) { _, time in
            setDate(date: date, time: time)
        }
        .onChange(of: includeTime) { _, _ in
            setDate(date: date, time: time)
        }
        .onChange(of: repeatAnnually) { _, _ in
            setDate(date: date, time: time)
        }
    }
    
    private func setDate(date: Date, time: Date) {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        let year = dateComponents.year ?? 0
        let month = dateComponents.month ?? 0
        let day = dateComponents.day ?? 0
        let hour = timeComponents.hour ?? 0
        let minute = timeComponents.minute ?? 0
        
        if repeatAnnually {
            if includeTime {
                occasion = .annualTime(calendar: "gregorian", month: month, day: day, hour: hour, minute: minute)
            } else {
                occasion = .annualDate(calendar: "gregorian", month: month, day: day)
            }
        } else {
            if includeTime {
                occasion = .singleTime(calendar: "gregorian", year: year, month: month, day: day, hour: hour, minute: minute)
            } else {
                occasion = .singleDate(calendar: "gregorian", year: year, month: month, day: day)
            }
        }
    }
}
