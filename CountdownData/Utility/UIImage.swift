//
//  UIImage.swift
//  CountdownData
//
//  Created by Joe Rupertus on 5/28/24.
//

import UIKit

public extension UIImage {
    
    func square() -> UIImage? {
        let originalSize = size
        let sideLength = min(originalSize.width, originalSize.height)
        let x = (originalSize.width - sideLength) / 2.0
        let y = (originalSize.height - sideLength) / 2.0
        let cropRect = CGRect(x: x, y: y, width: sideLength, height: sideLength)
        guard let cgImage = cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage + 20, height: size.height * percentage + 20)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizeData(withSize newSize: CGFloat) -> Data? {
        let canvasSize = CGSize(width: newSize * min(1.0, size.width/size.height), height: newSize * min(1.0, size.height/size.width))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image?.jpegData(compressionQuality: 0.8)
    }
    
//    func resizedIfTooLarge(withSize newSize: CGFloat) -> UIImage? {
//        guard size.height > newSize || size.width > newSize else { return self }
//        let canvasSize = CGSize(width: newSize * min(1.0, size.width/size.height), height: newSize * min(1.0, size.height/size.width))
//        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
//        defer { UIGraphicsEndImageContext() }
//        draw(in: CGRect(origin: .zero, size: canvasSize))
//        return UIGraphicsGetImageFromCurrentImageContext()
//    }

    func compressed(size: Double) -> Data? {
        guard let minimum = jpegData(compressionQuality: 0.9) else { return nil }
        var image: UIImage?
        var data: Data?
        
        if Double(minimum.count) > size {
            data = minimum
            image = UIImage(data: minimum)
            while Double(data?.count ?? 0) > size {
                image = image?.resized(withPercentage: 0.9)
                data = image?.jpegData(compressionQuality: 0.9)
            }
            return data
        }
        else {
            return minimum
        }
    }
    
    func cropped(offset: CGSize, scale: CGFloat) -> UIImage? {
        let normalizedImage: UIImage = {
            guard self.imageOrientation != .up else { return self }
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1.0
            let renderer = UIGraphicsImageRenderer(size: self.size, format: format)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: self.size))
            }
        }()

        let imageSize = normalizedImage.size
        let size = imageSize.minimum / scale
        let x = imageSize.width / 2 - imageSize.minimum * offset.width - size / 2
        let y = imageSize.height / 2 - imageSize.minimum * offset.height - size / 2
        let cropRect = CGRect(x: x, y: y, width: size, height: size)

        guard let cgImage = normalizedImage.cgImage?.cropping(to: cropRect) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: self.scale, orientation: .up)
    }
    
    func add(image: UIImage) -> UIImage? {
        let newSize = size
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        
        draw(in: CGRect(origin: .zero, size: newSize))
        image.draw(in: CGRect(origin: .zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

public extension Data {
    
    func resizeData(withSize newSize: CGFloat) -> Data? {
        if let image = UIImage(data: self) {
            return image.resizeData(withSize: newSize)
        }
        return nil
    }
}

public struct ImageData: Identifiable {
    public let id: UUID
    public let image: UIImage
    public let data: Data
    
    public init?(image: UIImage) {
        self.id = UUID()
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        self.data = data
        self.image = image
    }
}
