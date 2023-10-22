//
//  UnsplashMenu.swift
//  CountdownTime
//
//  Created by Joe Rupertus on 8/8/23.
//

import SwiftUI
import UIKit
import UnsplashPhotoPicker

struct UnsplashMenu: ViewModifier {
    
    let configuration = UnsplashPhotoPickerConfiguration(accessKey: "z1M58lDFUZLuCoaauev6ZwR8bnlzADQzrZ2Jhme25Cs", secretKey: "Tq393RwDCoziUZ9emJfSp2nA3s1vH2VFiqZjlviOEGg")
    
    @Binding var isPresented: Bool
    
    var onSelect: () -> Void
    var onReturn: (URL) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                UnsplashPhotoPickerView(configuration: configuration) { photos in
                    onSelect()
                    Task {
                        if let photo = photos.first, let url = photo.urls[.regular] {
                            onReturn(url)
                        }
                    }
                }
            }
    }
}

extension View {
    func unsplashMenu(isPresented: Binding<Bool>, onSelect: @escaping () -> Void, onReturn: @escaping (URL) -> Void) -> some View {
        modifier(UnsplashMenu(isPresented: isPresented, onSelect: onSelect, onReturn: onReturn))
    }
}

struct UnsplashPhotoPickerView: UIViewControllerRepresentable {
    
    let uiViewController: UnsplashPhotoPicker
    var onSelect: ([UnsplashPhoto]) -> Void
    
    init(configuration: UnsplashPhotoPickerConfiguration, onSelect: @escaping ([UnsplashPhoto]) -> Void) {
        self.uiViewController = UnsplashPhotoPicker(configuration: configuration)
        self.onSelect = onSelect
    }
    
    func makeUIViewController(context: Context) -> UnsplashPhotoPicker {
        return uiViewController
    }
    
    func updateUIViewController(_ uiViewController: UnsplashPhotoPicker, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(uiViewController, onSelect: onSelect)
    }
    
    class Coordinator: NSObject, UnsplashPhotoPickerDelegate {
        
        var onSelect: ([UnsplashPhoto]) -> Void
        
        init(_ uiViewController: UnsplashPhotoPicker, onSelect: @escaping ([UnsplashPhoto]) -> Void) {
            self.onSelect = onSelect
            super.init()
            uiViewController.photoPickerDelegate = self
        }
        
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            print("Unsplash: Selected \(photos.count) photos")
            onSelect(photos)
        }
        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
            print("Unsplash: Cancelled")
        }
    }
}
