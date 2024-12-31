//
//  CustomSlider.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/30/24.
//

import SwiftUI

struct CustomSlider: View {
    
    @Binding var value: Double
    
    let range: ClosedRange<Double>
    
    let mask: Bool
    let widen: Bool
    let opacityGrid: Bool
    let colors: [Color]
    
    private var progress: CGFloat {
        let clampedValue = min(max(value, range.lowerBound), range.upperBound)
        return CGFloat((clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound))
    }
    
    private let thumbDiameter: CGFloat = 30
    private let trackHeight: CGFloat = 20
    
    private var shape: some Shape {
        widen ? AnyShape(RoundedTrapezoid(cornerRadius: 5, sideInset: 5)) : AnyShape(RoundedRectangle(cornerRadius: 10))
    }
    
    public init(value: Binding<Double>, in range: ClosedRange<Double>, mask: Bool = false, widen: Bool = false, opacityGrid: Bool = false, colors: [Color] = [.white]) {
        self._value = value
        self.range = range
        self.mask = mask
        self.widen = widen
        self.opacityGrid = opacityGrid
        self.colors = colors
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                ZStack(alignment: .leading) {
                    
                    if mask {
                        shape
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: colors.map { $0.opacity(0.2) }),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: trackHeight)
                    }
                    if opacityGrid {
                        Checkerboard(rows: 3, columns: 3 * Int(totalWidth/trackHeight))
                            .fill(.white.opacity(0.5))
                            .frame(width: totalWidth, height: trackHeight)
                            .mask {
                                shape
                                    .frame(height: trackHeight)
                            }
                    }
                    
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: totalWidth, height: trackHeight)
                    .mask(alignment: .leading) {
                        if mask {
                            shape
                                .frame(width: totalWidth, height: trackHeight)
                                .mask(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: progress * totalWidth, height: trackHeight)
                                }
                        } else {
                            shape
                                .frame(width: totalWidth, height: trackHeight)
                        }
                    }
                    
                    Circle()
                        .fill(.tint)
                        .frame(width: thumbDiameter, height: thumbDiameter)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .offset(x: progress * (totalWidth - thumbDiameter))
                        .gesture(
                            DragGesture()
                                .onChanged { drag in
                                    // Clamp the drag location to 0...totalWidth
                                    let clampedX = min(max(0, drag.location.x), totalWidth)
                                    // Convert to 0...1 fraction
                                    let newProgress = clampedX / totalWidth
                                    // Convert that fraction back to the slider’s domain
                                    let newValue = range.lowerBound
                                    + Double(newProgress) * (range.upperBound - range.lowerBound)
                                    
                                    // Update the bound value
                                    value = newValue
                                }
                        )
                }
                Spacer(minLength: 0)
            }
        }
        .frame(minHeight: thumbDiameter)
    }
}

private struct RoundedTrapezoid: Shape {
    var cornerRadius: CGFloat = 20
    var sideInset: CGFloat = 40
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topLeft = CGPoint(x: rect.minX, y: rect.minY + sideInset)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY - sideInset)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // Start at top-left corner
        path.move(to: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y))
        
        // Top edge with rounded corners
        path.addLine(to: CGPoint(x: topRight.x - cornerRadius, y: topRight.y))
        path.addArc(
            center: CGPoint(x: topRight.x - cornerRadius, y: topRight.y + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: -90),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        
        // Right edge
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius))
        path.addArc(
            center: CGPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        
        // Bottom edge with rounded corners
        path.addLine(to: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y))
        path.addArc(
            center: CGPoint(x: bottomLeft.x + cornerRadius, y: bottomLeft.y - cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        
        // Left edge
        path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerRadius))
        path.addArc(
            center: CGPoint(x: topLeft.x + cornerRadius, y: topLeft.y + cornerRadius),
            radius: cornerRadius,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        
        return path
    }
}

private struct Checkerboard: Shape {
    let rows: Int
    let columns: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}



#Preview {
    @Previewable @State var previewValue = 50.0
    return VStack {
        CustomSlider(
            value: $previewValue,
            in: 0...100,
            colors: [Color.green, Color.pink]
        )
        .tint(.yellow)
        CustomSlider(
            value: $previewValue,
            in: 0...100,
            mask: true,
            colors: [Color.mint, Color.orange]
        )
        .tint(.blue)
        CustomSlider(
            value: $previewValue,
            in: 0...100,
            widen: true,
            colors: [Color.red, Color.cyan]
        )
        .tint(.green)
        CustomSlider(
            value: $previewValue,
            in: 0...100,
            opacityGrid: true,
            colors: [Color.clear, Color.purple]
        )
        .tint(.yellow)
        Spacer()
        Text(String(format: "Value: %.1f", previewValue))
            .foregroundColor(.white)
    }
    .padding()
    .background(Color.black)
}
