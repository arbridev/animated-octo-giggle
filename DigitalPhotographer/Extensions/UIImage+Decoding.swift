//
//  UIImage+Decoding.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/20/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

extension UIImage {

    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
    
    func dataSize() -> Int {
        if let data = self.pngData() {
            return NSData(data: data).length
        }
        return 0
    }
    
}
