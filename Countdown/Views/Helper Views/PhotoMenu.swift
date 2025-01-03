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
    
    var onReturn: (Data, ImageTransform) -> Void
    
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImage: ImageData?
    
    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: $isPresented, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) { _, newItem in
                Task {
                    if let newItem, let data = try? await newItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                        selectedImage = ImageData(image: image)
                    }
                }
            }
            .sheet(item: $selectedImage) { image in
                ImageTransformer(
                    image: image.image,
                    selectorShape: RoundedRectangle(cornerRadius: 35),
                    onConfirm: { offset, scale in
                        onReturn(image.data, ImageTransform(offset: offset, scale: scale))
                        selectedImage = nil
                    },
                    onCancel: {
                        selectedImage = nil
                    }
                )
            }
    }
}

extension View {
    func photoMenu(isPresented: Binding<Bool>, onReturn: @escaping (Data, ImageTransform) -> Void) -> some View {
        modifier(PhotoMenu(isPresented: isPresented, onReturn: onReturn))
    }
}
