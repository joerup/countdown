//
//  PhotoMenu.swift
//  Countdown
//
//  Created by Joe Rupertus on 7/22/23.
//

import SwiftUI
import PhotosUI
import CountdownData

struct PhotoMenu: ViewModifier {
    
    @Binding var isPresented: Bool
    
    var onSelect: () -> Void
    var onCancel: () -> Void
    var onReturn: (Card.BackgroundData) -> Void
    
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImage: ImageData?
    
    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: $isPresented, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { _, newItem in
                onSelect()
                Task {
                    if let newItem, let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                        selectedImage = ImageData(image: image)
                    }
                }
            }
            .sheet(item: $selectedImage) { image in
                ImageRepositionView(
                    image: image.image,
                    onConfirm: { offset, scale in
                        onReturn(.transformedPhoto(image.data, offsetX: offset.width, offsetY: offset.height, scale: scale))
                        selectedImage = nil
                    },
                    onCancel: {
                        onCancel()
                        selectedImage = nil
                    }
                )
            }
    }
}

extension View {
    func photoMenu(isPresented: Binding<Bool>, onSelect: @escaping () -> Void, onCancel: @escaping () -> Void, onReturn: @escaping (Card.BackgroundData) -> Void) -> some View {
        modifier(PhotoMenu(isPresented: isPresented, onSelect: onSelect, onCancel: onCancel, onReturn: onReturn))
    }
}
