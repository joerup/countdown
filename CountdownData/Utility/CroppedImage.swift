//
//  CroppedImage.swift
//  CountdownData
//
//  Created by Joe Rupertus on 12/23/24.
//

import SwiftUI

public struct CroppedImage: View {
    let image: UIImage
    let cropRect: CGRect
    
    public init(image: UIImage, cropRect: CGRect) {
        self.image = image
        self.cropRect = cropRect
    }

    public var body: some View {
        if let croppedCGImage = image.cgImage?.cropping(to: cropRect) {
            let croppedUIImage = UIImage(cgImage: croppedCGImage)
            Image(uiImage: croppedUIImage)
                .resizable()
                .scaledToFit()
        } else {
            Text("Unable to crop image")
                .foregroundColor(.red)
        }
    }
}
