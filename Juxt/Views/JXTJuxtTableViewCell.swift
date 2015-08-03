//
//  JXTJuxtTableViewCell.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import DOFavoriteButton

class JXTJuxtTableViewCell: PFTableViewCell {

    // MARK: Properties
    
    var currentPage: Int?
    
    var juxt: Juxt? {
        didSet {
            if let juxt = juxt, titleLabel = titleLabel, dateLabel = dateLabel {
                titleLabel.text = juxt.title
                if let date = juxt.date {
                    dateLabel.text = JXTConstants.stringFromDate(date)
                }
                
                galleryScrollView.juxt = self.juxt // For tap gesture

                
                // Profile Picture
                if let user = juxt.user {
                    let userQuery = PFQuery(className: "_User")
                    userQuery.getObjectInBackgroundWithId(user.objectId!, block: { (user, error) -> Void in
                        if error != nil {
                            println("\(error)")
                        } else {
                            self.usernameLabel.text = user?.objectForKey("name") as? String
                            
                            let file = user?.objectForKey("profilePicture") as? PFFile
                            self.profilePictureImageView.file = file
                            self.profilePictureImageView.loadInBackground()
                        }
                    })
                }
            }
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var galleryScrollView: JXTImageGalleryScrollView!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    override func prepareForReuse() {
        self.profilePictureImageView.image = UIImage(named: "default-placeholder")
        self.galleryScrollView.photos = nil
        self.galleryScrollView.images = nil 
    }
    
}