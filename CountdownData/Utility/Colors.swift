//
//  File.swift
//  CountdownData
//
//  Created by Joe Rupertus on 10/14/23.
//

import Foundation
import SwiftUI

public extension Color {
    
    static let standardColors: [Color] = [.gray, .pink, .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .brown]
    
    init(rgb: [Double]) {
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2])
    }
    
    var rgb: [Double] {
        guard let components = colorComponents else { return [0,0,0] }
        return [components.red, components.green, components.blue]
    }
    
    var red: Double {
        return rgb[0]
    }
    var green: Double {
        return rgb[1]
    }
    var blue: Double {
        return rgb[2]
    }
    
    func lighter(by percentage: CGFloat = 0.5) -> Color {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 0.5) -> Color {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 0.5) -> Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Color(UIColor(red: red + percentage*(1-red),
                           green: green + percentage*(1-green),
                           blue: blue + percentage*(1-blue),
                           alpha: alpha))
        } else {
            return self
        }
    }
    
    func discretizedGradient(numberOfShades: Int) -> [Color] {
        guard numberOfShades > 0 else { return [] }
        let intensityRange: CGFloat = 0.3

        // Extract RGB components from the base color
        let baseUIColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        baseUIColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        baseUIColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        guard saturation > 0.1 && brightness > 0.1 else { return [.blue, .red, .green, .yellow, .pink, .purple, .orange] }

        // Create an array to store the shades
        var gradientColors: [Color] = []

        // Calculate the step increment within the intensity range
        let step = intensityRange / CGFloat(numberOfShades - 1)

        // Generate shades closer to the base color (darker to lighter)
        for i in stride(from: -intensityRange, through: intensityRange, by: step) {
            let adjustedRed = min(max(red + i, 0), 1)
            let adjustedGreen = min(max(green + i, 0), 1)
            let adjustedBlue = min(max(blue + i, 0), 1)
            gradientColors.append(Color(red: adjustedRed, green: adjustedGreen, blue: adjustedBlue, opacity: alpha))
        }

        return gradientColors
    }
    
    func inverted() -> Color {
        return Color(rgb: [1-red, 1-green, 1-blue])
    }
}

extension Color: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case red, green, blue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        
        self.init(red: r, green: g, blue: b)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
    }
}


fileprivate extension Color {
    typealias SystemColor = UIColor
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
        
        return (r, g, b, a)
    }
}
