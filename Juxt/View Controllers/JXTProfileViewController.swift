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
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtils

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
    
    @IBAction func settingsButtonTapped(sender: UIButton) {
//        let section1 = JGActionSheetSection(title: self.nameLabel.text, message: nil, buttonTitles: ["Log Out"], buttonStyle: .Blue)
//        let cancelSection = JGActionSheetSection(title: nil, message: nil, buttonTitles: ["Cancel"], buttonStyle: .Cancel)
//        let sheet = JGActionSheet(sections: [section1, cancelSection])
//        sheet.buttonPressedBlock = { (sheet: JGActionSheet?, indexPath: NSIndexPath?) -> Void in
//            if let indexPath = indexPath, sheet = sheet {
//                if indexPath.row == 0 {
//                    PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
//                        if error == nil {
////                            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as? JXTLandingViewController
////                            if let loginVC = loginVC {
////                                self.presentViewController(loginVC, animated: true, completion: nil)
////                            }
//                            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//                        }
//                    })
//                }
//            }
//            sheet?.dismissAnimated(true)
//        }
//        sheet.showInView(self.view, animated: true)
        
        let alertController = UIAlertController(title: self.nameLabel.text, message: nil, preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
                if error == nil {
                    println("done")
                    PFFacebookUtils.session()?.closeAndClearTokenInformation()
                    FBSession.activeSession().closeAndClearTokenInformation()
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)

        alertController.addAction(logoutAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
