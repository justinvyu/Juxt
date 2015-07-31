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

    override func viewDidAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if PFUser.currentUser() != nil {
            
            let nameRequest = FBSDKGraphRequest(graphPath: "/me?fields=name,picture", parameters: nil, HTTPMethod: "GET")
            nameRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                if error != nil {
                    // Process error
                    println("Error: \(error)")
                } else {
                    println(result)
                    PFUser.currentUser()?.setValue(result.valueForKey("name") as? String, forKey: "name")
                    
                    let picture = result.valueForKey("picture") as? NSDictionary
                    let data = picture?.valueForKey("data") as? NSDictionary
                    let url = data?.valueForKey("url") as! String
                    
                    let imageData = NSData(contentsOfURL: NSURL(string: url)!)
                    
                    let imageFile = PFFile(data: imageData!)
                    imageFile.saveInBackground()
                    
                    PFUser.currentUser()?.setValue(imageFile, forKey: "profilePicture")
                    
                    PFUser.currentUser()?.saveEventually()
                    
                    //PFUser.currentUser()["name"] = result.valueForKey("name") as? NSString
                    //                    PFUser. = result.valueForKey("email") as? String
                }
            })
            
            // User is logged in, do work such as go to next view controller.
            let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
            self.presentViewController(mainNav!, animated: true, completion: nil)

        }
    }

    @IBAction func facebookAction(sender: FBSDKLoginButton) {
        if PFUser.currentUser() != nil {
            // User is logged in, do work such as go to next view controller.
            
//            PFUser.currentUser()["name"] =
            
                println("logged in")
                let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                self.presentViewController(mainNav!, animated: true, completion: nil)
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

extension JXTLandingViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            println("error: \(error?.localizedDescription)")
        } else {
            let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
            self.presentViewController(mainNav!, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
}
