//
//  AlertEditor.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 9/4/23.
//

import SwiftUI
import CountdownData

struct AlertEditor: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) var dismiss
    
    var countdown: Countdown
    
    @State private var alertsOn: Bool = false
    @State private var alerts: Set<Countdown.AlertTime> = []
    
    init(countdown: Countdown) {
        self.countdown = countdown
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Alerts", isOn: $alertsOn)
                }
                if alertsOn {
                    HStack {
                        Text("Countdown End")
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                    ForEach(Countdown.AlertTime.allCases, id: \.self) { alertTime in
                        Button {
                            if alerts.contains(alertTime) {
                                alerts.remove(alertTime)
                            } else {
                                alerts.insert(alertTime)
                            }
                        } label: {
                            HStack {
                                Text(alertTime.title)
                                    .foregroundStyle(.black)
                                Spacer()
                                if alerts.contains(alertTime) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Alerts")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveCountdown()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .tint(.pink)
        .onAppear {
            self.alertsOn = countdown.alertsOn
            self.alerts = countdown.alerts
        }
    }
    
    private func saveCountdown() {
        countdown.alertsOn = alertsOn
        countdown.alerts = alerts
    }
}
