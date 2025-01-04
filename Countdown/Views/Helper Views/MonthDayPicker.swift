//
//  MonthDayPicker.swift
//  Countdown
//
//  Created by Joe Rupertus on 1/4/25.
//

import SwiftUI

struct MonthDayPicker: View {
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int

    var body: some View {
        HStack {
            // Month Picker
            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(Calendar.current.monthSymbols[month - 1])
                        .tag(month)
                }
            }
            .pickerStyle(WheelPickerStyle())

            // Day Picker
            Picker("Day", selection: $selectedDay) {
                ForEach(1...daysInMonth(selectedMonth), id: \.self) { day in
                    Text("\(day)").tag(day)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .frame(height: 150)
        .onChange(of: selectedMonth) { _, month in
            // Ensure the selected day remains valid when the month changes
            let daysInSelectedMonth = daysInMonth(month)
            if selectedDay > daysInSelectedMonth {
                selectedDay = daysInSelectedMonth
            }
        }
    }
    
    func daysInMonth(_ month: Int) -> Int {
        let dateComponents = DateComponents(year: 2000, month: selectedMonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return calendar.range(of: .day, in: .month, for: date)!.count
    }
}

struct MonthDayPicker_Previews: PreviewProvider {
    @State static var month = 2
    @State static var day = 31
    
    static var previews: some View {
        MonthDayPicker(selectedMonth: $month, selectedDay: $day)
    }
}
