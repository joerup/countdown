//
//  Holiday.swift
//  CountdownData
//
//  Created by Joe Rupertus on 8/29/23.
//

import Foundation
    
public struct Holiday: Codable, Hashable {
    
    public var name: String
    public var displayName: String
    public var occasion: Occasion
    
    public static func get(_ name: String) -> Holiday? {
        if let holiday = all.first(where: { $0.name == name }) {
            return holiday
        } 
        return nil
    }
    
    public static var all: [Holiday] {
        if allHolidays.isEmpty {
            getAllHolidays()
        }
        return allHolidays
    }
    
    private static var allHolidays: [Holiday] = []
    private static func getAllHolidays() {
        guard let fileURL = Bundle.module.url(forResource: "holidays", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            allHolidays = try JSONDecoder().decode([Holiday].self, from: data)
        } catch {
            print("Error decoding holidays: \(error)")
        }
    }
}
