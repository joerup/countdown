//
//  BirthdayEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/29/23.
//

import SwiftUI
import CountdownData

struct BirthdayEditor: View {
    
    @Binding var name: String
    @Binding var destination: Countdown.Destination?
    
    @State private var myBirthday: Bool = true
    @State private var date: Date = .now
    
    var body: some View {
        List {
            Section {
                Picker("", selection: $myBirthday) {
                    Text("My Birthday").tag(true)
                    Text("Friend's Birthday").tag(false)
                }
                .pickerStyle(.segmented)
                if !myBirthday {
                    TextField("Name", text: $name)
                }
            }
            Section {
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            } header: {
                Text("Date of Birth")
            } footer: {
                if !name.isEmpty || myBirthday {
                    Text("\(myBirthday ? "Your" : "\(name)'s") birthday is \(date.mdString), \(String(date.component(.year))). \(myBirthday ? "You" : "They") are currently \(Calendar.current.dateComponents([.year], from: date, to: .now).year ?? 0) years old.")
                }
            }
        }
        .onAppear {
            if let destination, case .birthday(let year, let month, let day) = destination {
                self.date = Date(year: year, month: month, day: day)
                self.myBirthday = name == "My Birthday"
            } else {
                self.name = "My Birthday"
            }
        }
        .onChange(of: date) { _, date in
            self.destination = .birthday(year: date.component(.year), month: date.component(.month), day: date.component(.day))
        }
        .onChange(of: myBirthday) { _, myBirthday in
            if !myBirthday && name == "My Birthday" {
                name = ""
            }
        }
    }
}
