//
//  CGSize.swift
//  CountdownData
//
//  Created by Joe Rupertus on 12/23/24.
//

import CoreGraphics

public extension CGSize {
    
    var minimum: CGFloat {
        min(width, height)
    }
    var maximum: CGFloat {
        max(width, height)
    }
    
    var sign: CGSize {
        return CGSize(width: width/abs(width), height: height/abs(height))
    }
    
    // MARK: - Addition
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width,
                      height: lhs.height + rhs.height)
    }
    
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }
    
    // MARK: - Subtraction
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width,
                      height: lhs.height - rhs.height)
    }
    
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs - rhs
    }
    
    // MARK: - Multiplication by CGFloat
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs,
                      height: lhs.height * rhs)
    }
    
    static func * (lhs: CGFloat, rhs: CGSize) -> CGSize {
        return rhs * lhs
    }
    
    static func *= (lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs * rhs
    }
    
    // MARK: - Division by CGFloat
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / rhs,
                      height: lhs.height / rhs)
    }
    
    static func /= (lhs: inout CGSize, rhs: CGFloat) {
        lhs = lhs / rhs
    }
    
    // MARK: - Element-wise Multiplication by CGSize
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width,
                      height: lhs.height * rhs.height)
    }
    
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs * rhs
    }
    
    // MARK: - Element-wise Division by CGSize
    static func / (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width / rhs.width,
                      height: lhs.height / rhs.height)
    }
    
    static func /= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs / rhs
    }
}
