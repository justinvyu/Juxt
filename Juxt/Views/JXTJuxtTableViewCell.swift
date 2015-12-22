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
import Bond

class JXTJuxtTableViewCell: PFTableViewCell {

    // MARK: Properties
    
    weak var homeViewController: JXTHomeTableViewController?
    weak var profileViewController: JXTProfileViewController?
//    var likeBond: Bond<[PFUser]?>!

    var currentPage: Int?
    
    var juxt: Juxt? {
        didSet {
            if let juxt = juxt, titleLabel = titleLabel, dateLabel = dateLabel, sideBySideView = sideBySideView {
                                
                titleLabel.text = juxt.title
                if let date = juxt.date {
                    dateLabel.text = JXTConstants.stringFromDate(date)
                }
                
                juxt.user?.fetchInBackgroundWithBlock({ (user, error) -> Void in
                    if error != nil {
                        print("\(error)")
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.usernameLabel.text = user?[ParseHelper.UserName] as? String
                            self.profilePictureImageView.file = user?[ParseHelper.UserProfilePicture] as? PFFile
                            self.profilePictureImageView.loadInBackground()
                            self.profilePictureImageView.contentMode = .ScaleAspectFill
//                            self.profilePictureImageView.image = UIImage(named: "splash")
                        }
                    }
                })
                
//                self.likeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
                
//                juxt.likes ->> likeBond
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
//            if let likeList = likeList {
//                print(likeList.count)
////                self.likeButton.setTitle("\(likeList.count)", forState: .Normal)
//                self.likesLabel.text = "\(likeList.count)"
//                if let user = PFUser.currentUser() {
//                    self.likeButton.selected = likeList.contains(user)
//                }
////                self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
//            }
//        }

        juxt?.likes.observe({ likeList in
            if let likeList = likeList {
                print(likeList.count)
                self.likeButton.setTitle("\(likeList.count)", forState: .Normal)
                self.likesLabel.text = "\(likeList.count)"
                if let user = PFUser.currentUser() {
                    self.likeButton.selected = likeList.contains(user)
                }
            self.likeButton.selected = likeList.contains(PFUser.currentUser()!) //contains(likeList, PFUser.currentUser()!)
            }
        })
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
        
//        self.sideBySideView.leftPhoto?.image = UIImage(named: "default-placeholder")
//        self.sideBySideView.rightPhoto?.image = UIImage(named: "default-placeholder")

        self.sideBySideView.leftPhoto?.image = UIImage(named: "default-placeholder")
        self.sideBySideView.rightPhoto?.image = UIImage(named: "default-placeholder")
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
    
    @IBAction func likeButtonPressed(sender: UIButton) {
        
        self.juxt?.toggleLikePost(PFUser.currentUser()!)
    }
    
    @IBAction func moreButtonPressed(sender: UIButton) {
        
        if let juxt = self.juxt {
            homeViewController?.showActionSheetForPost(juxt)
            profileViewController?.showActionSheetForPost(juxt)
        }
        
    }
}