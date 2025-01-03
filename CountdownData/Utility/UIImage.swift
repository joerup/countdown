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
    
    func resized(withSize newSize: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: newSize * min(1.0, size.width/size.height), height: newSize * min(1.0, size.height/size.width))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedIfTooLarge(withSize newSize: CGFloat) -> UIImage? {
        guard size.height > newSize || size.width > newSize else { return self }
        let canvasSize = CGSize(width: newSize * min(1.0, size.width/size.height), height: newSize * min(1.0, size.height/size.width))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

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
    
    func withTextOverlay(text: String, textColor: UIColor = .black, font: UIFont = UIFont.systemFont(ofSize: 200), atPoint point: CGPoint) -> UIImage {
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor,
        ] as [NSAttributedString.Key : Any]
        
        // Create a bitmap graphics context of the given size
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        // Put the image into a rectangle as large as the original image
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        // Create a point within the space that is as big as the image
        let rect = CGRect(x: point.x, y: point.y, width: self.size.width, height: self.size.height)
        
        // Draw the text into an image
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        // Return the new image
        return newImage ?? self
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
