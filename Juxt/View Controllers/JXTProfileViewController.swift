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
        
    }
    
    // Helper Funcs
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
