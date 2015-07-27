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

enum GalleryScrollViewDirection {
    case Horizontal
    case Vertical
}

class JXTImageGalleryScrollView: UIScrollView {

    let imagePadding: CGFloat = 10.0
    var imageSize: CGSize? // 100x100 - 20 = 80x80
    
    var direction: GalleryScrollViewDirection? = .Horizontal
    var photos: [Photo]? {
        didSet {
            displayGallery(photos)
        }
    }
    
    func displayGallery(photos: [Photo]?) {
        
        self.imageSize = self.imageSize ?? CGSizeMake(95, 95)
        
        self.pagingEnabled = true
        
        self.subviews.map { $0.removeFromSuperview() }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if let photos = photos {
                let paddingWidth = CGFloat(photos.count + 1) * self.imagePadding
                let imageWidth = CGFloat(photos.count) * self.imageSize!.width
                let imageHeight = CGFloat(photos.count) * self.imageSize!.height
                let contentWidth = self.imageSize!.width
                let contentHeight = self.imageSize!.height + self.imagePadding
                
                if self.direction == .Horizontal {
                    self.contentSize = CGSizeMake(paddingWidth + imageWidth, contentHeight)
                } else if self.direction == .Vertical {
                    self.contentSize = CGSizeMake(contentWidth, paddingWidth + imageHeight)
                }
                
                for var i = 0; i < photos.count; i++ {
                    var xPos: CGFloat = 0.0
                    var yPos: CGFloat = 0.0
                    
                    let padding = self.imagePadding * CGFloat(i + 1)
                    if self.direction == .Horizontal {
                        xPos = CGFloat(padding) + CGFloat(i) * self.imageSize!.width
                    } else  if self.direction == .Vertical {
                        yPos = CGFloat(padding) + CGFloat(i) * self.imageSize!.height
                    }
                    
                    var imageView = PFImageView(frame: CGRectMake(xPos, yPos, self.imageSize!.width, self.imageSize!.height))
                    imageView.contentMode = .ScaleAspectFill
                    imageView.image = UIImage(named: "default-placeholder")
                    self.addSubview(imageView)
                    JXTConstants.fadeInWidthDuration(imageView, duration: 0.3)
                    imageView.file = photos[i].imageFile
                    imageView.layer.cornerRadius = 5.0
                    imageView.clipsToBounds = true
                    imageView.loadInBackground()
                }
            }
        }
    }
        
}
