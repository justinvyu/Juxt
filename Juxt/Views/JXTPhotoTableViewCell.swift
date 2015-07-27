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

class JXTPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: PFImageView!
    
    var photo: Photo? {
        
        didSet {
            
            if let photo = self.photo {
                photoView.file = photo.imageFile
                photoView.layer.cornerRadius = 5.0
                photoView.contentMode = .ScaleAspectFill
                photoView.clipsToBounds = true
                photoView.image = UIImage(named: "default-placeholder")
                titleLabel.text = photo.title
                if let date = photo.date {
                    dateLabel.text = JXTConstants.stringFromDate(date)
                }
                
                photoView.loadInBackground()
            }
            
        }
        
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
