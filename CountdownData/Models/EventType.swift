//
//  EventType.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/21/23.
//

import Foundation
import EventKit

public enum EventType: String, Codable, CaseIterable, Identifiable {
    
    case holiday
    case custom
    
    public var id: Self { self }
    
}
