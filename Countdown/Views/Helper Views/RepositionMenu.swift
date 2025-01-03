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
    var transform: ImageTransform
    
    var onReturn: (ImageTransform) -> Void
    
    init(isPresented: Binding<Bool>, image: UIImage? = nil, transform: ImageTransform?, onReturn: @escaping (ImageTransform) -> Void) {
        self._isPresented = isPresented
        self.image = image
        self.transform = transform ?? .init()
        self.onReturn = onReturn
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                if let image {
                    ImageTransformer(
                        image: image,
                        initialOffset: transform.offset,
                        initialScale: transform.scale,
                        selectorShape: RoundedRectangle(cornerRadius: 35),
                        onConfirm: { offset, scale in
                            onReturn(ImageTransform(offset: offset, scale: scale))
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
    func repositionMenu(isPresented: Binding<Bool>, image: UIImage?, transform: ImageTransform?, onReturn: @escaping (ImageTransform) -> Void) -> some View {
        self.modifier(RepositionMenu(isPresented: isPresented, image: image, transform: transform, onReturn: onReturn))
    }
}
