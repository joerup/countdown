//
//  OccasionEditor.swift
//  Countdown
//
//  Created by Joe Rupertus on 7/20/23.
//

import SwiftUI
import CountdownData

struct OccasionEditor: View {
    
    @Binding var name: String
    @Binding var displayName: String
    @Binding var occasion: Occasion?
    @Binding var type: EventType
    
    var body: some View {
        switch type {
        case .holiday:
            HolidayDetails(name: $name, displayName: $displayName, occasion: $occasion)
        case .custom:
            DateEditor(name: $name, displayName: $displayName, occasion: $occasion)
        }
    }
}

