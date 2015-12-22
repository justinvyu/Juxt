//
//  JXTSideBySideView.swift
//  Juxt
//
//  Created by Justin Yu on 8/6/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class JXTSideBySideView: UIView {

    var leftPhoto: PFImageView?
    var rightPhoto: PFImageView?
    
    var photos: [Photo]? {
        didSet {
            //println(photos)
            if photos != nil {
                displayPhotos(photos!)
            }
        }
    }
    
    func displayPhotos(photos: [Photo]) {
        
        self.leftPhoto = nil
        self.rightPhoto = nil
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        self.leftPhoto = PFImageView(image: UIImage(named: "default-placeholder"))
        self.leftPhoto?.frame = CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height)
        self.leftPhoto?.contentMode = .ScaleAspectFill
        self.leftPhoto?.clipsToBounds = true
        
        if photos.count >= 2 {
            let left = photos[0]
            let right = photos[photos.count - 1]
            
            self.rightPhoto = PFImageView(image: UIImage(named: "default-placeholder"))
            self.rightPhoto?.frame = CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height)
            self.rightPhoto?.contentMode = .ScaleAspectFill
            self.rightPhoto?.clipsToBounds = true
            
            leftPhoto?.file = left.imageFile
            rightPhoto?.file = right.imageFile
            

        } else if photos.count == 1 {
            let left = photos[0]
            
            leftPhoto?.file = left.imageFile
            rightPhoto?.removeFromSuperview()
        }
        
        leftPhoto?.loadInBackground()
        rightPhoto?.loadInBackground()
        
        self.addSubview(leftPhoto!)
        if let rightPhoto = rightPhoto {
            self.addSubview(rightPhoto)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
