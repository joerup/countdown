//
//  PhotoMenu.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 7/22/23.
//

import SwiftUI
import PhotosUI

struct PhotoMenu: ViewModifier {
    
    @Binding var isPresented: Bool
    
    var onSelect: (Data) -> Void
    
    @State private var photoItem: PhotosPickerItem?
    
    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: $isPresented, selection: $photoItem)
            .onChange(of: photoItem) {
                Task {
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data), let photoData = compress(image) {
                            self.onSelect(photoData)
                            return
                        }
                    }
                    print("Failed")
                }
            }
    }
    
    private func compress(_ photo: UIImage, compressionQuality: Double = 1.0) -> Data? {
        if let data = photo.jpegData(compressionQuality: compressionQuality) {
            if data.count >= 750000 { // limit to about 750 KB, otherwise
                return compress(photo, compressionQuality: compressionQuality*0.8)
            } else {
                return data
            }
        }
        return nil
    }
}

extension View {
    func photoMenu(isPresented: Binding<Bool>, onSelect: @escaping (Data) -> Void) -> some View {
        modifier(PhotoMenu(isPresented: isPresented, onSelect: onSelect))
    }
}
