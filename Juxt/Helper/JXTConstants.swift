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
    
    static func displayErrorAlert(vc: UIViewController, text: String, desc: String) {
        let alertController = UIAlertController(title: text, message: desc, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))

        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
