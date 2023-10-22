//
//  CountdownEditor.swift
//  CountdownTime
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
    @State private var deleteCountdown = false
    
    var body: some View {
        HStack {
            Button("", systemImage: "calendar") {
                clock.pause {
                    editDestination.toggle()
                }
            }
            Button("", systemImage: "trash") {
                clock.pause {
                    deleteCountdown.toggle()
                }
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
        .alert("Delete Countdown", isPresented: $deleteCountdown) {
            Button("Cancel", role: .cancel) {
                deleteCountdown = false
            }
            Button("Delete", role: .destructive) {
                clock.unscheduleNotifications(for: countdown)
                modelContext.delete(countdown)
                withAnimation {
                    onDelete()
                }
            }
        } message: {
            Text("Are you sure you want to delete this countdown? This action cannot be undone.")
        }
    }
}

