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
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    private var sortedCountdowns: [Countdown] {
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
    
    private var showMultipleCards: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    @State private var showSettings: Bool = false
    @State private var showArchive: Bool = false
    @State private var showSearch: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var newCountdown: Bool = false
    @State private var editingCountdown: Countdown?
    
    @State private var viewType: ViewType = .grid
    private enum ViewType {
        case grid, carousel
    }
    
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewType {
                case .grid:
                    CountdownGrid(countdowns: sortedCountdowns, showArchive: showArchive, animation: animation) { countdown in
                        clock.select(countdown)
                        if showMultipleCards {
                            viewType = .carousel
                        }
                    }
                case .carousel:
                    CountdownCarousel(countdowns: sortedCountdowns, editingCountdown: $editingCountdown, showMultipleCards: showMultipleCards, animation: animation)
                }
            }
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
        .opacity(clock.selectedCountdown == nil || showMultipleCards ? 1 : 0)
        .overlay {
            if !showMultipleCards, clock.selectedCountdown != nil {
                CountdownCarousel(countdowns: sortedCountdowns, editingCountdown: $editingCountdown, showMultipleCards: showMultipleCards, animation: animation)
            }
        }
        .tint(.pink)
        .sheet(isPresented: $newCountdown) {
            OccasionCreator { countdown in
                clock.select(countdown)
                editingCountdown = countdown
            }
            .presentationBackground(Material.thin)
        }
        .sheet(isPresented: $showSettings) {
            SettingsMenu()
                .presentationBackground(Material.thin)
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
            if premium.isActive || clock.countdowns.filter({ !$0.isPastDay }).count < 4 {
                Button {
                    newCountdown.toggle()
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            } else {
                Button {
                    premium.showPurchaseScreen.toggle()
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
        }
    }
}
