//
//  Holiday.swift
//
//
//  Created by Joe Rupertus on 8/29/23.
//

import Foundation
    
public struct Holiday: Codable, Hashable {
    
    public var id: Int
    public var name: String
    public var displayName: String
    public var date: Occasion
    
    private static var allHolidays: [Holiday]?
    public static var all: [Holiday] {
        if let allHolidays {
            return allHolidays
        } else {
            self.allHolidays = loadHolidays()
            return allHolidays ?? []
        }
    }
    
    public static func get(from id: Int) -> Holiday? {
        return all.first(where: { $0.id == id })
    }
    
    private static func loadHolidays() -> [Holiday]? {
        guard let fileURL = Bundle.module.url(forResource: "holidays", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Holiday].self, from: data)
        } catch {
            print("Error decoding holidays: \(error)")
            return nil
        }
    }
}
