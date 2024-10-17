//
//  CountdownView.swift
//  Countdown
//
//  Created by Joe Rupertus on 5/7/23.
//

import SwiftUI
import Foundation
import CountdownData
import CountdownUI

struct CountdownView: View {
    
    @Environment(Clock.self) private var clock
    @Environment(Premium.self) private var premium
    
    @Environment(\.requestReview) private var requestReview
    @AppStorage("reviewOpens") private var reviewOpens: Int = 0
    
    var sortedCountdowns: [Countdown] {
        if !searchText.isEmpty {
            return (clock.countdowns.filter {  $0.name.lowercased().starts(with: searchText.lowercased()) } .sorted()
                    + clock.countdowns.filter { $0.name.lowercased().contains(searchText.lowercased()) && !$0.name.lowercased().starts(with: searchText.lowercased()) } .sorted())
            .filter { showArchive ? $0.isComplete : !$0.isPastDay }
        } else if showArchive {
            return clock.countdowns.filter { $0.isComplete } .sorted().reversed()
        } else {
            return clock.countdowns.filter { !$0.isPastDay } .sorted()
        }
    }
    
    @State private var editing: Bool = false
    
    @State private var showSettings: Bool = false
    @State private var showArchive: Bool = false
    @State private var showSearch: Bool = false
    @State private var showPremium: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var newCountdown: EventType? = nil
    
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            CountdownGrid(countdowns: sortedCountdowns, showArchive: showArchive, animation: animation)
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
        .opacity(clock.selectedCountdown == nil ? 1 : 0)
        .overlay {
            if let _ = clock.selectedCountdown {
                CountdownCarousel(countdowns: sortedCountdowns, editing: $editing, animation: animation)
            }
        }
        .tint(.pink)
        .sheet(item: $newCountdown) { type in
            OccasionEditor(type: type) { countdown in
                clock.select(countdown)
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
            if premium.isActive || clock.countdowns.filter(\.isActive).count < 4 {
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
