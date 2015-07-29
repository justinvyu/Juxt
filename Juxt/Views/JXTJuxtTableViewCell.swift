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
                // Setup gallery view
            }
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var galleryScrollView: JXTImageGalleryScrollView!
    @IBOutlet weak var profilePictureImageView: UIImageView!

    override func prepareForReuse() {
        self.galleryScrollView.photos = nil
        self.galleryScrollView.subviews.map { $0.removeFromSuperview() }
    }
    
}