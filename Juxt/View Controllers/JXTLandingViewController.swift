//
//  JXTLandingViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/14/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import FlatUIKit
import Parse
import ParseFacebookUtils

class JXTLandingViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = JXTConstants.defaultBlueColor()
        facebookButton.layer.cornerRadius = 5.0
        twitterButton.layer.cornerRadius = 5.0
        
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() != nil {
            
            // User is logged in, do work such as go to next view controller.
            let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
            self.presentViewController(mainNav!, animated: true, completion: nil)

        }
    }

    @IBAction func facebookAction(sender: FBSDKLoginButton) {
        if PFUser.currentUser() != nil {
            // User is logged in, do work such as go to next view controller.
            
//            PFUser.currentUser()["name"] =
                let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                self.presentViewController(mainNav!, animated: true, completion: nil)
        } else {
            ParseHelper.loginWithFacebook({ (user, error) -> Void in
                if user == nil {
                    println("Uh oh. The user cancelled the Facebook login.")
                } else if user!.isNew == true {
                    println("User signed up and logged in through Facebook!")
                    let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                    self.presentViewController(mainNav!, animated: true, completion: nil)
                } else {
                    println("User logged in through Facebook!")
                    let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                    self.presentViewController(mainNav!, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func twitterAction(sender: UIButton) {
        
    }
    
}

//extension JXTLandingViewController: FBSDKLoginButtonDelegate {
//    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        if error != nil {
//            println("error: \(error?.localizedDescription)")
//        } else {
//            println("logged in")
//
//        }
//    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        
//    }
//    
//}
