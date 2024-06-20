//
//  CountdownGrid.swift
//  Countdown.messages
//
//  Created by Joe Rupertus on 5/28/24.
//

import SwiftUI
import CountdownData
import CountdownUI

struct CountdownGrid: View {
    
    @EnvironmentObject var clock: Clock
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(MessageController.self) var controller
    
    var countdowns: [Countdown]
    
    private var sortedCountdowns: [Countdown] {
        return countdowns.filter { !$0.isPastDay } .sorted()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let columns = horizontalSizeClass == .compact ? 2 : Int(geometry.size.width/180)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                    ForEach(sortedCountdowns) { countdown in
                        Button {
                            controller.createMessage(for: countdown)
                        } label: {
                            CountdownSquare(countdown: countdown)
                                .cornerRadius(20)
                                .aspectRatio(1.0, contentMode: .fill)
                                .frame(maxWidth: 200)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .shadow(radius: 10)
                        .padding(5)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
}
