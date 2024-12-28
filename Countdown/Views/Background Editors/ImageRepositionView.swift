//
//  ImageRepositionView.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/23/24.
//

import SwiftUI
import CountdownData

typealias ImageCompletion = (_ offset: CGSize, _ scale: CGFloat) -> Void

struct ImageRepositionView: View {
    
    var image: UIImage
    
    var initialOffset: CGSize
    var initialScale: CGFloat
    
    var onConfirm: ImageCompletion
    var onCancel: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var lastDragOffset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    let padding: CGFloat = 50
    
    private var selectorShape: some Shape {
        RoundedRectangle(cornerRadius: 30)
    }
    
    init(image: UIImage, initialOffset: CGSize = .zero, initialScale: CGFloat = 1.0, onConfirm: @escaping ImageCompletion, onCancel: @escaping () -> Void) {
        self.image = image
        self.initialOffset = initialOffset
        self.initialScale = initialScale
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        self.dragOffset = dragOffset
        self.lastDragOffset = lastDragOffset
        self.currentScale = currentScale
        self.lastScale = lastScale
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .offset(dragOffset)
                    .scaleEffect(geometry.size.minimum / image.size.minimum)
                    .scaleEffect(currentScale)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay {
                        let origin = CGPoint(x: max((geometry.size.width - geometry.size.height) / 2, 0), y: max((geometry.size.height - geometry.size.width) / 2, 0))
                        Rectangle()
                            .subtracting(
                                selectorShape
                                    .path(in: .init(x: origin.x + padding, y: origin.y + padding, width: geometry.size.minimum, height: geometry.size.minimum))
                            )
                            .fill(Color(UIColor.systemBackground).opacity(0.5))
                            .padding(-padding)
                        selectorShape
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: geometry.size.minimum, height: geometry.size.minimum)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = lastDragOffset + value.translation * image.size.minimum / geometry.size.minimum / currentScale
                                clamp(size: geometry.size)
                            }
                            .onEnded { _ in
                                lastDragOffset = dragOffset
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { scale in
                                currentScale = lastScale * scale
                                clamp(size: geometry.size)
                            }
                            .onEnded { _ in
                                lastScale = currentScale
                            }
                    )
            }
            .padding(padding)
            .onAppear {
                self.dragOffset = initialOffset
                self.currentScale = initialScale
                self.lastDragOffset = dragOffset
                self.lastScale = currentScale
            }
            .clipped()
            .navigationBarItems(
                leading: Button("Cancel") {
                    onCancel()
                },
                trailing: Button {
                    onConfirm(dragOffset, currentScale)
                } label: {
                    Text("Apply")
                        .fontWeight(.semibold)
                }
            )
        }
    }
    
    private func clamp(size: CGSize) {
        let size = image.size / 2
        
        // Define minimum and maximum scale factors
        let minScale: CGFloat = 1.0
        let maxScale: CGFloat = 3.0
        
        // Clamp the currentScale within the defined range
        if currentScale < minScale {
            currentScale = minScale
            lastScale = minScale
        } else if currentScale > maxScale {
            currentScale = maxScale
            lastScale = maxScale
        }
        
        // Determine the maximum allowable offset in each direction
        let maxOffsetX = size.width - size.minimum / currentScale
        let maxOffsetY = size.height - size.minimum / currentScale
        
        // Clamp the dragOffset to ensure the image stays within bounds
        dragOffset.width = min(max(dragOffset.width, -maxOffsetX), maxOffsetX)
        dragOffset.height = min(max(dragOffset.height, -maxOffsetY), maxOffsetY)
    }
}
