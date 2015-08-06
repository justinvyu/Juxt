//
//  JXTConstants.swift
//  Juxt
//
//  Created by Justin Yu on 7/15/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class JXTConstants: NSObject {
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    static func defaultBlueColor() -> UIColor {
        return UIColor(red: 99/255, green: 195/255, blue: 251/255, alpha: 1.0)
    }
    
    static func fontWithSize(size: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir Next", size: size)
    }

    static func fadeInWidthDuration(view: UIView, duration: NSTimeInterval) {
        
        view.alpha = 0.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            view.alpha = 1.0
        })
        
    }
    
    static func fadeOutWithDuration(view: UIView, duration: NSTimeInterval) {
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            view.alpha = 0.0
        }) { (finished) -> Void in
            view.removeFromSuperview()
        }
        
    }
    
    static func stringFromDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
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
    
}
