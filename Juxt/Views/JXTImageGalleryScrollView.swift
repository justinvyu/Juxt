//
//  JXTImageGalleryScrollView.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class JXTImageGalleryScrollView: UIScrollView {

    let imagePadding: CGFloat = 10.0
    let imageSize: CGSize = CGSizeMake(95, 95) // 100x100 - 20 = 80x80
    
    var photos: [Photo]? {
        didSet {
            displayGallery(photos)
        }
    }
    
    func displayGallery(photos: [Photo]?) {
        
        self.subviews.map { $0.removeFromSuperview() }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let photos = photos {
                let paddingWidth = CGFloat(photos.count + 1) * self.imagePadding
                let imageWidth = CGFloat(photos.count) * self.imageSize.width
                let contentHeight = self.imageSize.height + self.imagePadding
                
                self.contentSize = CGSizeMake(paddingWidth + imageWidth, contentHeight)
                
                for var i = 0; i < photos.count; i++ {
                    let xPos = self.imagePadding * CGFloat(i) + CGFloat(i) * self.imageSize.width
                    //println(xPos)
                    
                    var imageView = PFImageView(frame: CGRectMake(xPos, 0, self.imageSize.width, self.imageSize.height))
                    imageView.contentMode = .ScaleAspectFill
                    imageView.image = UIImage(named: "default-placeholder")
                    self.addSubview(imageView)
                    
                    imageView.file = photos[i].imageFile
                    imageView.layer.cornerRadius = 5.0
                    imageView.clipsToBounds = true
                    imageView.loadInBackground()
                }
            }
        }
    }
        
}
