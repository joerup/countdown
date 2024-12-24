//
//  CountdownGrid.swift
//  Countdown
//
//  Created by Joe Rupertus on 10/18/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownGrid: View {
    
    @Environment(Clock.self) private var clock
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var countdowns: [Countdown]
    
    var showArchive: Bool
    
    @State private var editDestination: Bool = false
    @State private var editDestinationValue: Countdown?
    @State private var shareCountdown: Bool = false
    @State private var shareCountdownValue: Countdown?
    @State private var deleteCountdown: Bool = false
    @State private var deleteCountdownValue: Countdown?
    
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let columns = horizontalSizeClass == .compact ? 2 : Int(geometry.size.width/180)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                    ForEach(countdowns) { countdown in
                        Button {
                            withAnimation {
                                clock.select(countdown)
                            }
                        } label: {
                            CountdownSquare(countdown: countdown)
                                .aspectRatio(1.0, contentMode: .fill)
                                .frame(maxWidth: 200)
                                .background(Color.blue.opacity(0.2))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 22.5))
                        .shadow(radius: 5)
                        .id(clock.tick)
                        .contextMenu {
                            Button {
                                self.editDestinationValue = countdown
                                self.editDestination.toggle()
                            } label: {
                                Label("Edit Date", systemImage: "calendar")
                            }
//                            Button {
//                                self.shareCountdownValue = countdown
//                                self.shareCountdown.toggle()
//                            } label: {
//                                Label("Share", systemImage: "square.and.arrow.up")
//                            }
                            Button(role: .destructive) {
                                self.deleteCountdownValue = countdown
                                self.deleteCountdown.toggle()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .padding(5)
                    }
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $editDestination) {
                if let countdown = editDestinationValue {
                    OccasionEditor(countdown: countdown)
                }
            }
            .sheet(isPresented: $shareCountdown) {
                if let countdown = shareCountdownValue {
                    ShareMenu(countdown: countdown)
                }
            }
            .alert("Delete Countdown", isPresented: $deleteCountdown) {
                Button("Cancel", role: .cancel) {
                    deleteCountdown = false
                    deleteCountdownValue = nil
                }
                if let countdown = deleteCountdownValue {
                    Button("Delete", role: .destructive) {
                        clock.delete(countdown)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this countdown? This action cannot be undone.")
            }
            .refreshable {
                await clock.refresh()
            }
        }
    }
}
