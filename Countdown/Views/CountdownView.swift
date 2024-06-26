//
//  CountdownView.swift
//  Countdown
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
    
    @Environment(\.requestReview) private var requestReview
    @AppStorage("reviewOpens") private var reviewOpens: Int = 0
    
    var countdowns: [Countdown]
    var sortedCountdowns: [Countdown] {
        if !searchText.isEmpty {
            return countdowns.filter {  $0.name.lowercased().starts(with: searchText.lowercased()) } .sorted()
            + countdowns.filter { $0.name.lowercased().contains(searchText.lowercased()) && !$0.name.lowercased().starts(with: searchText.lowercased()) } .sorted()
        } else if showArchive {
            return countdowns.filter { $0.isComplete } .sorted().reversed()
        } else {
            return countdowns.filter { !$0.isPastDay } .sorted()
        }
    }
    
    @EnvironmentObject var premium: Premium
    
    @Binding var selectedCountdown: Countdown?
    
    @State private var editing: Bool = false
    
    @State private var showSettings: Bool = false
    @State private var showArchive: Bool = false
    @State private var showSearch: Bool = false
    @State private var showPremium: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var newCountdown: EventType? = nil
    
    var body: some View {
        NavigationStack {
            CountdownGrid(countdowns: sortedCountdowns, selectedCountdown: $selectedCountdown, showArchive: showArchive)
                .navigationBarTitleDisplayMode(.inline)
                .overlay {
                    if sortedCountdowns.isEmpty {
                        Text(!searchText.isEmpty ? "No matching countdowns found." : showArchive ? "Completed countdowns will appear here." : "No countdowns are currently active!")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                            .padding(50)
                    }
                }
                .toolbar {
                    headerButtons
                }
        }
        .searchable(text: $searchText, isPresented: $showSearch, placement: .navigationBarDrawer)
        .opacity(selectedCountdown == nil ? 1 : 0)
        .overlay {
            if selectedCountdown != nil {
                CountdownCarousel(countdowns: sortedCountdowns, selectedCountdown: $selectedCountdown, editing: $editing)
            }
        }
        .tint(.pink)
        .sheet(item: $newCountdown) { type in
            OccasionEditor(type: type) { countdown in
                self.selectedCountdown = countdown
                self.editing = true
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsMenu()
        }
        .sheet(isPresented: $showPremium) {
            PremiumView()
        }
        .onAppear {
            if !premium.isActive, Int.random(in: 1...5) == 5 {
                showPremium = true
            }
            else {
                reviewOpens += 1
                if reviewOpens >= 7 {
                    requestReview()
                    reviewOpens = 0
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var headerButtons: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Countdowns")
                .fontWeight(.semibold)
        }
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
            }
        }
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker("", selection: $showArchive) {
                    Text("Upcoming").tag(false)
                    Text("Archive").tag(true)
                }
                .onChange(of: showArchive) { _, _ in
                    UIImpactFeedbackGenerator().impactOccurred()
                }
            } label: {
                Image(systemName: "archivebox\(showArchive ? ".fill" : "")")
                    .fontWeight(.medium)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showSearch.toggle()
            } label: {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.medium)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if premium.isActive || countdowns.filter({ $0.isActive }).count < 4 {
                Menu {
                    ForEach(EventType.allCases) { type in
                        Button(type.displayName) {
                            newCountdown = type
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            } else {
                Button {
                    showPremium.toggle()
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
        }
    }
}
