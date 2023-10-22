//
//  Other.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 5/6/23.
//

import Foundation
import SwiftUI
import UIKit
import EventKit


public extension GeometryProxy {
    
    var totalSize: CGSize {
        CGSize(width: size.width + safeAreaInsets.leading + safeAreaInsets.trailing, height: size.height + safeAreaInsets.top + safeAreaInsets.bottom)
    }
}

public extension UIImage {

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func compressed(size: Double) -> Data? {
        guard let minimum = jpegData(compressionQuality: 0) else { return nil }
        var image: UIImage?
        var data: Data?
        
        if Double(minimum.count) > size {
            data = minimum
            image = UIImage(data: minimum)
            while Double(data?.count ?? 0) > size {
                print("looping \(data?.count ?? 0)")
                image = image?.resized(withPercentage: 0.9)
                data = image?.jpegData(compressionQuality: 0)
            }
            return data
        }
        else {
            return minimum
        }
    }
}

public extension Int {
    
    var ordinalString: String {
        if self == -1 {
            return "last"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(for: self) ?? String(self)
    }
}

extension Calendar.Identifier {

    public init(_ string: String) {
        switch string {
        case "gregorian": self = .gregorian
        case "hebrew": self = .hebrew
        case "chinese": self = .chinese
        case "islamic": self = .islamicCivil
        case "hindu": self = .indian
        default: self = .iso8601
        }
    }
    
    public var name: String {
        return String("\(self)").capitalized
    }
}
