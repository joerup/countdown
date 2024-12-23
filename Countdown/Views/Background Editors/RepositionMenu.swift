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
    
    var data: Card.BackgroundData?
    var image: UIImage?
    var initialOffset: CGSize?
    var initialScale: CGFloat?
    
    var onConfirm: (Card.BackgroundData) -> Void
    
    init(isPresented: Binding<Bool>, image: UIImage?, data: Card.BackgroundData?, onConfirm: @escaping (Card.BackgroundData) -> Void) {
        self._isPresented = isPresented
        self.data = data
        self.image = image
        self.initialOffset = data?.transforms.offset
        self.initialScale = data?.transforms.scale
        self.onConfirm = onConfirm
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                if let image, let initialOffset, let initialScale {
                    ImageRepositionView(
                        image: image,
                        initialOffset: initialOffset,
                        initialScale: initialScale,
                        onConfirm: { offset, scale in
                            if let newData = data?.repositioned(offset: offset, scale: scale) {
                                onConfirm(newData)
                            }
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
    func repositionMenu(isPresented: Binding<Bool>, image: UIImage?, data: Card.BackgroundData?, onConfirm: @escaping (Card.BackgroundData) -> Void) -> some View {
        self.modifier(RepositionMenu(isPresented: isPresented, image: image, data: data, onConfirm: onConfirm))
    }
}
