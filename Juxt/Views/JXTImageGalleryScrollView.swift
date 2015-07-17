//
//  JXTImageGalleryScrollView.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class JXTImageGalleryScrollView: UIScrollView {

    let imagePadding: CGFloat = 10.0
    let imageSize: CGSize = CGSizeMake(80.0, 80.0) // 100x100 - 20 = 80x80
    
    var images: [JXTImage]? {
        didSet {
            displayGallery(images)
        }
    }
    
    func displayGallery(images: [JXTImage]?) {
        println("Displaying Gallery")
        
        if let images = images {
            let paddingWidth = CGFloat(images.count + 1) * imagePadding
            let imageWidth = CGFloat(images.count) * imageSize.width
            let contentHeight = imageSize.height + imagePadding
            
            self.contentSize = CGSizeMake(paddingWidth + imageWidth, contentHeight)
            
            for var i = 0; i < images.count; i++ {
                let xPos = paddingWidth + CGFloat(i) * imageWidth
                
                var imageView = UIImageView(frame: CGRectMake(xPos, imagePadding, imageSize.width, imageSize.height))
                self.addSubview(imageView)
            }
        }
        
    }

}
