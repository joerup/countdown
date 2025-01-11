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
    
    var animation: Namespace.ID
    
    var onSelect: (Countdown) -> Void
    
    @State private var editCountdown: Countdown?
    
    @State private var deleteCountdown: Bool = false
    @State private var deleteCountdownValue: Countdown?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let columns = horizontalSizeClass == .compact ? 2 : Int(geometry.size.width/180)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                    ForEach(countdowns) { countdown in
                        Button {
                            withAnimation {
                                onSelect(countdown)
                            }
                        } label: {
                            CountdownSquare(countdown: countdown)
                                .aspectRatio(1.0, contentMode: .fill)
                                .frame(maxWidth: 200)
                                .background(Color.blue.opacity(0.2))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 22.5))
                        .shadow(radius: 5)
                        .contextMenu {
                            Button {
                                self.editCountdown = countdown
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
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
            .sheet(item: $editCountdown) { countdown in
                CountdownEditor(countdown: countdown) { _ in }
            }
            .alert("Delete \(deleteCountdownValue?.displayName ?? "Countdown")", isPresented: $deleteCountdown) {
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
