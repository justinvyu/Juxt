//
//  JXTHeaderTableViewCell.swift
//  Juxt
//
//  Created by Justin Yu on 8/6/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bond

class JXTHeaderTableViewCell: UITableViewCell {

    weak var juxtViewController: JXTJuxtViewController?
    
//    var likeBond: Bond<[PFUser]?>!
    var juxt: Juxt? {
        didSet {
            if let user = juxt?.user {
                user.fetchIfNeededInBackgroundWithBlock({ (user, error) -> Void in
                    if error != nil {
                        print("\(error)")
                    } else {
                        self.usernameLabel.text = ParseHelper.userName(user as! PFUser)
                        self.profilePicture.file = ParseHelper.userProfilePicture(user as! PFUser)
                        self.profilePicture.loadInBackground()
                    }
                })

            }
            self.profilePicture.layer.cornerRadius = 5.0
            self.titleLabel.text = juxt?.title
            
            otherButton.setImage(juxt?.user?.objectId == PFUser.currentUser()?.objectId ? UIImage(named: "delete") : UIImage(named: "flag"), forState: .Normal)
            otherButton.setImage(juxt?.user?.objectId == PFUser.currentUser()?.objectId ? UIImage(named: "delete") : UIImage(named: "flag"), forState: .Selected)
            otherButton.setImage(juxt?.user?.objectId == PFUser.currentUser()?.objectId ? UIImage(named: "delete") : UIImage(named: "flag"), forState: .Highlighted)

            juxt?.likes.observe({ likeList in
                if let likeList = likeList {
                    self.likesLabel.text = "\(likeList.count)"
                    self.likeButton.selected = likeList.contains(PFUser.currentUser()!)
                }
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var otherButton: UIButton! // Flag or delete
    
    @IBAction func likeButtonPressed(sender: UIButton) {

        self.juxt?.toggleLikePost(PFUser.currentUser()!)
        
    }
    
    @IBAction func otherButtonPressed(sender: UIButton) {
        
        if let juxt = self.juxt {
            self.juxtViewController?.showActionSheetForPost(juxt)
        }
        
    }
    
    @IBAction func compareButtonPressed(sender: UIButton) {
        self.juxtViewController?.showSideBySideScreen()
    }
    
    @IBAction func gifButtonPressed(sender: UIButton) {
        self.juxtViewController?.showGIFScreen()
    }
}
