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

class JXTJuxtTableViewCell: PFTableViewCell {

    // MARK: Properties
    
    static var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var juxt: Juxt? {
        didSet {
            if let juxt = juxt, titleLabel = titleLabel, dateLabel = dateLabel, galleryScrollView = galleryScrollView {
                titleLabel.text = juxt.title
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateLabel.text = dateFormatter.stringFromDate(juxt.date!)
                // Setup gallery view
            }
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var galleryScrollView: JXTImageGalleryScrollView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
}
