//
//  ImageHelper.swift
//  Juxt
//
//  Created by Justin Yu on 8/11/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class ImageHelper: NSObject {
   
    static func scaleImage(image: UIImage, width: CGFloat) -> UIImage {
        let oldWidth = image.size.width
        let scaleFactor = width / oldWidth
        
        let newHeight = image.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // Juxtapose images
    static func combineImage(image firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        var image: UIImage
        
        var newImageSize = CGSizeMake(firstImage.size.width + secondImage.size.width, max(firstImage.size.height, secondImage.size.height))
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.mainScreen().scale)
        
        var borderedFirstImage = firstImage.borderImage(UIColor(white: 0.97, alpha: 1.0), borderWidth: 30)
        var borderedSecondImage = secondImage.borderImage(UIColor(white: 0.97, alpha: 1.0), borderWidth: 30)
        borderedFirstImage.drawAtPoint(CGPointMake(0, 0))
        borderedSecondImage.drawAtPoint(CGPointMake(firstImage.size.width - 15, 0))
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func generateGIFWithImages(images: [UIImage]) {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingPathComponent("animated.gif")
        let destination = CGImageDestinationCreateWithURL(NSURL(fileURLWithPath: path!) as! CFURLRef, kUTTypeGIF, images.count, nil)
        let frameProperties = [kCGImagePropertyGIFDelayTime as String : NSNumber(int: 2)]
        let gifProperties = [kCGImagePropertyGIFLoopCount as String : NSNumber(int: 0)]
        
        for image in images {
            CGImageDestinationAddImage(destination, image.CGImage, frameProperties)
        }
        CGImageDestinationSetProperties(destination, gifProperties)
        CGImageDestinationFinalize(destination)
        println("animated GIF file created at \(path)")
    }
    
}

extension UIImage {
    
    func borderImage(color: UIColor, borderWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawAtPoint(CGPointZero)
        color.setStroke()
        var path = UIBezierPath(rect: CGRectMake(0, 0, self.size.width, self.size.height))
        path.lineWidth = borderWidth
        path.stroke()
        var result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}