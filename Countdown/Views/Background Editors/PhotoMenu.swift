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
    var onReturn: (Data) -> Void
    
    @State private var photoItem: PhotosPickerItem?
    
    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: $isPresented, selection: $photoItem, matching: .images)
            .onChange(of: photoItem) {
                onSelect()
                Task {
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        // limit to 750 kB for safe storage in CloudKit
                        if let image = UIImage(data: data), let photoData = image.compressed(size: Card.maxPhotoSize) {
                            onReturn(photoData)
                        }
                    }
                }
            }
    }
}

extension View {
    func photoMenu(isPresented: Binding<Bool>, onSelect: @escaping () -> Void, onReturn: @escaping (Data) -> Void) -> some View {
        modifier(PhotoMenu(isPresented: isPresented, onSelect: onSelect, onReturn: onReturn))
    }
}
