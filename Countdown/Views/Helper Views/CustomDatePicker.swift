//
//  CustomDatePicker.swift
//  Countdown
//
//  Created by Joe Rupertus on 1/11/24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var date: Date
    @State private var selectedMonth: Int = 1
    @State private var selectedDay: Int = 1
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    let showYear: Bool // Toggle for showing the year
    
    private let calendar = Calendar.current
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }()
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) { // No spacing between pickers
                let totalWidth = geometry.size.width
                let monthWidth = showYear ? totalWidth * 0.5 : totalWidth * 0.5
                let dayWidth = showYear ? totalWidth * 0.25 : totalWidth * 0.5
                let yearWidth = totalWidth * 0.25
                
                // Month Picker
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(formatter.monthSymbols[month - 1])
                            .tag(month)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 5)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: monthWidth)
                
                // Day Picker
                Picker("Day", selection: $selectedDay) {
                    ForEach(1...maxDaysInMonth(), id: \.self) { day in
                        Text("\(day)")
                            .tag(day)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 5)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: dayWidth)
                
                // Year Picker (Optional)
                if showYear {
                    Picker("Year", selection: $selectedYear) {
                        ForEach(2000...2400, id: \.self) { year in
                            Text(numberFormatter.string(from: NSNumber(value: year)) ?? "\(year)")
                                .tag(year)
                                .minimumScaleFactor(0.5)
                                .padding(.horizontal, 5)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: yearWidth)
                }
            }
        }
        .onChange(of: selectedMonth) { _, _ in updateDateAndDayRange() }
        .onChange(of: selectedDay) { _, _ in updateDate() }
        .onChange(of: selectedYear) { _, _ in updateDateAndDayRange() }
        .onAppear {
            initializePickers()
        }
    }
    
    private func maxDaysInMonth() -> Int {
        let components = DateComponents(year: showYear ? selectedYear : 2000, month: selectedMonth)
        return calendar.range(of: .day, in: .month, for: calendar.date(from: components)!)?.count ?? 31
    }
    
    private func updateDateAndDayRange() {
        selectedDay = min(selectedDay, maxDaysInMonth())
        updateDate()
    }
    
    private func initializePickers() {
        let components = calendar.dateComponents([.month, .day, .year], from: date)
        selectedMonth = components.month ?? 1
        selectedDay = components.day ?? 1
        selectedYear = components.year ?? 2000
    }
    
    private func updateDate() {
        var components = DateComponents()
        components.month = selectedMonth
        components.day = selectedDay
        components.year = showYear ? selectedYear : 2000 // Use 2000 as a leap year if year is not shown
        if let newDate = calendar.date(from: components) {
            date = newDate
        }
    }
}

#Preview {
    @Previewable @State var date: Date = .now
    
    return Group {
        CustomDatePicker(date: $date, showYear: true)
        CustomDatePicker(date: $date, showYear: false)
    }
}
