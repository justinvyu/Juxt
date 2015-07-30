//
//  JXTPhotoTableViewCell.swift
//  Juxt
//
//  Created by Justin Yu on 7/22/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol JXTPhotoTableViewCellDelegate {
    
    func imageViewWasPressedWithImage(image: UIImage)
    
}

class JXTPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: PFImageView!
    
    var delegate: JXTPhotoTableViewCellDelegate?
    
    var photo: Photo? {
        
        didSet {
            
            if let photo = self.photo {
                photoView.file = photo.imageFile
                photoView.layer.cornerRadius = 5.0
                photoView.contentMode = .ScaleAspectFill
                photoView.clipsToBounds = true
                photoView.image = UIImage(named: "default-placeholder")
                
                let tapGesture = UITapGestureRecognizer(target: self, action: "photoTapped:")
                photoView.addGestureRecognizer(tapGesture)
                photoView.userInteractionEnabled = true
                
                titleLabel.text = photo.title
                if let date = photo.date {
                    dateLabel.text = JXTConstants.stringFromDate(date)
                }
                
                photoView.loadInBackground()
            }
            
        }
    }
    
    func photoTapped(gesture: UITapGestureRecognizer) {
        println("tapped")
        if let image = self.photoView.image {
            self.delegate?.imageViewWasPressedWithImage(image)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}