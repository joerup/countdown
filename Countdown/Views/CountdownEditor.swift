//
//  CountdownEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 7/21/23.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownEditor: View {
    
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var clock: Clock
    
    var countdown: Countdown
    
    @Binding var editing: Bool
    
    var onDelete: () -> Void
    
    @State private var editDestination = false
    @State private var shareCountdown = false
    @State private var deleteCountdown = false
    
    var body: some View {
        HStack {
            Button {
                clock.pause {
                    editDestination.toggle()
                }
            } label: {
                Image(systemName: "calendar")
                    .padding(5)
            }
            Button {
                clock.pause {
                    shareCountdown.toggle()
                }
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .padding(5)
            }
            Button {
                clock.pause {
                    deleteCountdown.toggle()
                }
            } label: {
                Image(systemName: "trash")
                    .padding(5)
            }
            Spacer()
            Button {
                clock.pause {
                    editing = false
                }
            } label: {
                Text("Done")
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $editDestination) {
            OccasionEditor(countdown: countdown)
        }
        .sheet(isPresented: $shareCountdown) {
            ShareMenu(countdown: countdown)
        }
        .alert("Delete Countdown", isPresented: $deleteCountdown) {
            Button("Cancel", role: .cancel) {
                deleteCountdown = false
            }
            Button("Delete", role: .destructive) {
                clock.unscheduleNotifications(for: countdown)
                modelContext.delete(countdown)
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this countdown? This action cannot be undone.")
        }
    }
}

