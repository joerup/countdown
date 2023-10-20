//
//  CountdownView.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/7/23.
//

import SwiftUI
import Foundation
import SwiftData
import CountdownData
import CountdownUI

struct CountdownView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var countdowns: [Countdown]
    var sortedCountdowns: [Countdown] {
        countdowns.filter { $0.date.midnight >= .now.midnight } .sorted { $0.date < $1.date }
    }
    
    @Binding var selectedCountdown: Countdown?
    
    @State private var editing: Bool = false
    @State private var showSettings: Bool = false
    @State private var newCountdown: EventType? = nil
    
    @State private var confettiTrigger: Int = 0
    
    var body: some View {
        NavigationStack {
            CountdownGrid(countdowns: sortedCountdowns, selectedCountdown: $selectedCountdown)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    headerButtons
                }
        }
        .opacity(selectedCountdown == nil ? 1 : 0)
        .overlay {
            if let selectedCountdown {
                if editing {
                    CountdownEditor(countdown: selectedCountdown, editing: $editing, onDelete: { self.selectedCountdown = nil })
                } else {
                    CountdownCarousel(countdowns: sortedCountdowns, selectedCountdown: $selectedCountdown, editing: $editing)
                }
            }
        }
        .tint(.pink)
        .sheet(item: $newCountdown) { type in
            OccasionEditor(type: type)
        }
        .sheet(isPresented: $showSettings) {
            SettingsMenu()
        }
    }
    
    @ToolbarContentBuilder
    private var headerButtons: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Countdowns")
                .fontDesign(.rounded)
                .fontWeight(.bold)
        }
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                ForEach(EventType.allCases) { type in
                    Button(type.rawValue.capitalized) {
                        newCountdown = type
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.bold)
            }
        }
    }
}
