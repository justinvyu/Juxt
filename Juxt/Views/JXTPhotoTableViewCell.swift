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
    
    weak var juxtViewController: JXTJuxtViewController?
    
//    var delegate: JXTPhotoTableViewCellDelegate?
    
    var photo: Photo? {
        
        didSet {
            
            if let photo = self.photo {
                photoView.file = photo.imageFile
                photoView.layer.cornerRadius = 5.0
                photoView.contentMode = .ScaleAspectFill
                photoView.clipsToBounds = true
                photoView.image = UIImage(named: "default-placeholder")
                
                self.photoView?.frame = CGRectMake(15, 40, self.frame.size.width - 30, self.frame.size.width - 30)
                self.layoutIfNeeded()
                let tapGesture = UITapGestureRecognizer(target: self, action: "photoTapped:")
                photoView.addGestureRecognizer(tapGesture)
                photoView.userInteractionEnabled = true
                
                titleLabel.text = photo.title
                self.titleLabel.frame = CGRectMake(15, 11, self.frame.size.width - 30, self.frame.size.width - 30)
                if let date = photo.date {
                    dateLabel.text = JXTConstants.stringFromDate(date)
                }
                
                photoView.loadInBackground()
            }
            
        }
    }
    
    func photoTapped(gesture: UITapGestureRecognizer) {
        if let image = self.photoView.image {
//            self.delegate?.imageViewWasPressedWithImage(image)
            self.juxtViewController?.showFullScreenImage(image)
        }
    }
    
    @IBAction func moreButtonPressed(sender: UIButton) {
        if let photo = self.photo {
            self.juxtViewController?.showActionSheetForPhoto(photo)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
}
