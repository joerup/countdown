//
//  DateEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/1/23.
//

import SwiftUI
import CountdownData

struct DateEditor: View {
    
    @Binding var name: String
    @Binding var destination: Countdown.Destination?
    
    @State private var date: Date = .now
    @State private var time: Date = .now
    
    @State private var repeatAnnually: Bool = false
    
    var body: some View {
        List {
            Section("Name") {
                TextField("Event Name", text: $name)
            }
            Section {
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
            Section {
                DatePicker("Time", selection: $time, displayedComponents: [.hourAndMinute])
            }
            Section {
                Toggle("Repeat Annually", isOn: $repeatAnnually)
            }
            
//            if let destination, case .custom(let date) = destination {
//                Section { } header: {
//                    HStack {
//                        Spacer()
//                        Text("\(includeTime ? date.fullString : date.string)")
//                            .fontWeight(.bold)
//                            .textCase(nil)
//                        Spacer()
//                    }
//                }
//            }
        }
        .onAppear {
            if let destination, case .custom(let date) = destination {
                self.date = date.next
                self.time = date.next
                if case .annualDate(_, _, _) = date {
                    self.repeatAnnually = true
                }
            } else {
                self.date = .midnight
                self.time = .midnight
            }
        }
        .onChange(of: date) { _, date in
            setDate(date: date, time: time)
        }
        .onChange(of: time) { _, time in
            setDate(date: date, time: time)
        }
        .onChange(of: repeatAnnually) { _, _ in
            setDate(date: date, time: time)
        }
    }
    
    private func setDate(date: Date, time: Date) {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year ?? 0
        combinedComponents.month = dateComponents.month ?? 0
        combinedComponents.day = dateComponents.day ?? 0
        combinedComponents.hour = timeComponents.hour ?? 0
        combinedComponents.minute = timeComponents.minute ?? 0
        combinedComponents.second = timeComponents.second ?? 0
        
        let combinedDate = calendar.date(from: combinedComponents) ?? .now
        if repeatAnnually {
            self.destination = .custom(date: .annualDate(calendar: "gregorian", month: combinedDate.component(.month), day: combinedDate.component(.day)))
        } else {
            self.destination = .custom(date: .singleDate(combinedDate))
        }
    }
}
