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
    
    var onSelect: (UIImage) -> Void
    
    @State private var photoItem: PhotosPickerItem?
    
    func body(content: Content) -> some View {
        content
            .photosPicker(isPresented: $isPresented, selection: $photoItem)
            .onChange(of: photoItem) {
                Task {
                    if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            self.onSelect(image)
                            return
                        }
                    }
                    print("Failed")
                }
            }
    }
}

extension View {
    func photoMenu(isPresented: Binding<Bool>, onSelect: @escaping (UIImage) -> Void) -> some View {
        modifier(PhotoMenu(isPresented: isPresented, onSelect: onSelect))
    }
}
