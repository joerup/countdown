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
    
    let sliderShape: SliderShape
    
    let colors: [Color]
    
    enum SliderShape {
        case straight, widening
    }
    
    private var progress: CGFloat {
        let clampedValue = min(max(value, range.lowerBound), range.upperBound)
        return CGFloat((clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound))
    }
    
    private let thumbDiameter: CGFloat = 30
    private let trackHeight: CGFloat = 20
    
    private var shape: some Shape {
        switch sliderShape {
        case .straight:
            AnyShape(RoundedRectangle(cornerRadius: 10))
        case .widening:
            AnyShape(RoundedTrapezoid(cornerRadius: 5, sideInset: 7))
        }
    }
    
    public init(value: Binding<Double>, in range: ClosedRange<Double>, shape: SliderShape = .straight, colors: [Color]) {
        self._value = value
        self.range = range
        self.sliderShape = shape
        self.colors = colors
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            
            ZStack(alignment: .leading) {
                
                shape
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: colors.map { $0.opacity(0.2) }),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: trackHeight)
                
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: totalWidth, height: trackHeight)
                .mask(alignment: .leading) {
                    shape
                        .frame(width: totalWidth, height: trackHeight)
//                        .mask(alignment: .leading) {
//                            Rectangle()
//                                .frame(width: progress * totalWidth, height: trackHeight)
//                        }
                }
                
                Circle()
                    .fill(.tint)
                    .frame(width: thumbDiameter, height: thumbDiameter)
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .offset(x: (progress * totalWidth) - (thumbDiameter / 2))
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
        }
        .frame(minHeight: thumbDiameter)
    }
}

struct RoundedTrapezoid: Shape {
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

#Preview {
    @Previewable @State var previewValue = 50.0
    return VStack {
        CustomSlider(
            value: $previewValue,
            in: 0...100,
            shape: .widening,
            colors: [Color.red, Color.cyan]
        )
        .tint(.green)
        Text(String(format: "Value: %.1f", previewValue))
            .foregroundColor(.white)
    }
    .padding()
    .background(Color.black)
}
