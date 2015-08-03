//
//  JXTProfileViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/28/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class JXTProfileViewController: UIViewController {

    // Properties
    
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = PFUser.currentUser()?["name"] as? String
        
        let file = PFUser.currentUser()?.objectForKey("profilePicture") as? PFFile
        self.profilePicture.file = file
        self.profilePicture.loadInBackground()
        
        self.profilePicture.layer.cornerRadius = 5.0
    }
    
    // Helper Funcs
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
