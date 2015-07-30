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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = JXTConstants.defaultBlueColor()
        
//        let fbLogin = FBSDKLoginButton()
//        fbLogin.frame = CGRectMake(0, 0, self.view.frame.width - 100, 40)
//        fbLogin.center = self.view.center
//        //fbLogin.delegate = self
//        fbLogin.frame.origin.y += 50
        
//        self.view.addSubview(fbLogin)
        
//        let twitterLogin = TWTRLogInButton(logInCompletion: {
//            (session: TWTRSession!, error: NSError!) in
//            // play with Twitter session
//        })
//        twitterLogin.frame = CGRectMake(0, 0, self.view.frame.width - 100, 40)
//        twitterLogin.center = self.view.center
//        
//        twitterLogin.frame.origin.y += 100
//        self.view.addSubview(twitterLogin)
        
    }

    override func viewWillAppear(animated: Bool) {
//        self.loginWithFacebook()
    }

    @IBAction func facebookAction(sender: UIButton) {
        if PFUser.currentUser() != nil {
            // User is logged in, do work such as go to next view controller.
                println("logged in")
                let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                self.presentViewController(mainNav!, animated: true) {
                    println(PFUser.currentUser())
            }
        } else {
            self.loginWithFacebook()
        }
    }
    
    @IBAction func twitterAction(sender: UIButton) {
        
    }
    
    func loginWithFacebook() {
        let permissionsArray = ["email", "public_profile", "user_friends"]
        
//        PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user, error) -> Void in
//            if user == nil {
//                println("Uh oh. The user cancelled the Facebook login.")
//            } else if user!.isNew == true {
//                println("User signed up and logged in through Facebook!")
//            } else {
//                println("User logged in through Facebook!")
//            }
//        })
        
        PFFacebookUtils.logInWithPermissions(permissionsArray) { (user, error) -> Void in
            if user == nil {
                println("Uh oh. The user cancelled the Facebook login.")
            } else if user!.isNew == true {
                println("User signed up and logged in through Facebook!")
            } else {
                println("User logged in through Facebook!")
            }
        }
    }
    
}

//extension JXTLandingViewController: FBSDKLoginButtonDelegate {
//    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        if error != nil {
//            println("error: \(error?.localizedDescription)")
//        } else {
//            let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
//            self.presentViewController(mainNav!, animated: true, completion: nil)
//        }
//    }
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        
//    }
//    
//}
