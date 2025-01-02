//
//  RepositionMenu.swift
//  Countdown
//
//  Created by Joe Rupertus on 12/23/24.
//

import SwiftUI
import CountdownData

struct RepositionMenu: ViewModifier {
    
    @Binding var isPresented: Bool
    
    var image: UIImage?
    var data: Card.BackgroundData?
    var transform: Card.ImageTransform?
    
    var onReturn: (Card.BackgroundData, Card.ImageTransform) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                if let image, let transform {
                    ImageTransformer(
                        image: image,
                        initialOffset: transform.offset,
                        initialScale: transform.scale,
                        selectorShape: RoundedRectangle(cornerRadius: 20),
                        onConfirm: { offset, scale in
                            guard let data else { return }
                            let transform = Card.ImageTransform(offset: offset, scale: scale)
                            onReturn(data, transform)
                            isPresented = false
                        },
                        onCancel: {
                            isPresented = false
                        }
                    )
                }
            }
    }
}

extension View {
    func repositionMenu(isPresented: Binding<Bool>, image: UIImage?, data: Card.BackgroundData?, transform: Card.ImageTransform?, onReturn: @escaping (Card.BackgroundData, Card.ImageTransform) -> Void) -> some View {
        self.modifier(RepositionMenu(isPresented: isPresented, image: image, data: data, transform: transform, onReturn: onReturn))
    }
}
