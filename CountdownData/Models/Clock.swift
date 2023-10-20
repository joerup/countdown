//
//  Clock.swift
// 
//
//  Created by Joe Rupertus on 10/19/23.
//

import Foundation

public final class Clock: ObservableObject {
    
    @Published public var tick: Bool
    
    @Published public var active: Bool
    
    private var times: [UUID : Double]
    
    public init() {
        self.tick = false
        self.active = true
        self.times = [:]
    }
    
    public func pause() {
        active = false
    }
    public func start() {
        active = true
    }
    
    public func setTimeRemaining(for countdown: Countdown) {
        times[countdown.id] = countdown.date.timeIntervalSinceNow
    }
    
    public func timeRemaining(for countdown: Countdown) -> Double? {
        return times[countdown.id]
    }
    
    public func daysRemaining(for countdown: Countdown) -> Int {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: countdown.date < .now ? .now : countdown.date.midnight)
        guard let day = components.day, let hour = components.hour, let minute = components.minute, let second = components.second else { return 0 }
        return day + (hour <= 0 && minute <= 0 && second <= 0 ? 0 : 1)
    }
    
    public func componentsRemaining(for countdown: Countdown) -> DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute, .second], from: .now, to: countdown.date < .now ? .now : countdown.date)
    }
}
