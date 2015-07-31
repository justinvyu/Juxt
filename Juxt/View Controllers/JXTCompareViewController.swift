//
//  JXTCompareViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/27/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class JXTCompareViewController: UIViewController {
    
    var photos: [Photo]?
    var compareView: JXTCompareView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photos = photos {
            compareView = JXTCompareView(frame: self.view.frame, photos: photos)
            self.view.addSubview(compareView!)
        }
    }

}

extension UIImage {
    
    // Merge two images
//    
//    - (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
//    UIImage *image = nil;
//    
//    CGSize newImageSize = CGSizeMake(MAX(firstImage.size.width, secondImage.size.width), MAX(firstImage.size.height, secondImage.size.height));
//    if (UIGraphicsBeginImageContextWithOptions != NULL) {
//    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
//    } else {
//    UIGraphicsBeginImageContext(newImageSize);
//    }
//    [firstImage drawAtPoint:CGPointMake(roundf((newImageSize.width-firstImage.size.width)/2),
//    roundf((newImageSize.height-firstImage.size.height)/2))];
//    [secondImage drawAtPoint:CGPointMake(roundf((newImageSize.width-secondImage.size.width)/2),
//    roundf((newImageSize.height-secondImage.size.height)/2))];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//    }
    
    
}