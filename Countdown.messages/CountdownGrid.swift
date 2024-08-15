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
    
    var countdowns: [Countdown]
    var createMessage: (Countdown) -> ()
    
    private var sortedCountdowns: [Countdown] {
        return countdowns.filter { !$0.isPastDay } .sorted()
    }
    
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach(sortedCountdowns) { countdown in
                        Button {
                            createMessage(countdown)
                        } label: {
                            CountdownSquare(countdown: countdown, animation: animation)
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
