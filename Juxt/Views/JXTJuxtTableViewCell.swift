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
    
    weak var homeViewController: JXTHomeTableViewController?
    
    var currentPage: Int?
    
    var juxt: Juxt? {
        didSet {
            if let juxt = juxt, titleLabel = titleLabel, dateLabel = dateLabel, sideBySideView = sideBySideView {
                                
                titleLabel.text = juxt.title
                if let date = juxt.date {
                    dateLabel.text = JXTConstants.stringFromDate(date)
                }
                
//                // Profile Picture WTF WAS I THINKING
//                if let user = juxt.user {
//                    let userQuery = PFQuery(className: "_User")
//                    userQuery.getObjectInBackgroundWithId(user.objectId!, block: { (user, error) -> Void in
//                        if error != nil {
//                            println("\(error)")
//                        } else {
//                            self.usernameLabel.text = user?.objectForKey("name") as? String
//                            
//                            let file = user?.objectForKey("profilePicture") as? PFFile
//                            self.profilePictureImageView.file = file
//                            self.profilePictureImageView.loadInBackground()
//                        }
//                    })
//                }
                
                juxt.user?.fetchIfNeededInBackgroundWithBlock({ (user, error) -> Void in
                    if error != nil {
                        println("\(error)")
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.usernameLabel.text = user?[ParseHelper.UserName] as? String
                            self.profilePictureImageView.file = user?[ParseHelper.UserProfilePicture] as? PFFile
                            self.profilePictureImageView.loadInBackground()
                        }
                    }
                })
                
                
            
            }
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var sideBySideView: JXTSideBySideView!
    
//    @IBOutlet weak var flagButton: UIButton!
    
    override func prepareForReuse() {
//        self.profilePictureImageView.image = UIImage(named: "default-placeholder")
//        self.galleryScrollView.photos = nil
//        self.galleryScrollView.images = nil
//        self.sideBySideView.photos = nil
        self.sideBySideView.subviews.map { $0.removeFromSuperview() }
    }
//
//    @IBAction func flaggedContentButtonPressed(sender: UIButton) {
//
//        self.juxt?.toggleFlagPost(PFUser.currentUser()!)
//        if let usersFlagged = self.juxt?.usersFlagged {
//            sender.selected = contains(usersFlagged, PFUser.currentUser()!)
//            println(contains(usersFlagged, PFUser.currentUser()!))
//        }
//    }
    
    @IBAction func moreButtonPressed(sender: UIButton) {
        
        if let juxt = self.juxt {
            homeViewController?.showActionSheetForPost(juxt)
        }
        
    }
}