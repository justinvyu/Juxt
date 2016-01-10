//
//  JXTLandingViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/14/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse
import ConvenienceKit

class JXTLandingViewController: UIViewController {

//    @IBOutlet weak var facebookButton: UIButton!
//    @IBOutlet weak var twitterButton: UIButton!
//    @IBOutlet weak var facebookImage: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = JXTConstants.defaultBlueColor()
//        facebookButton.layer.cornerRadius = 5.0
//        twitterButton.layer.cornerRadius = 5.0
//        self.view.bringSubviewToFront(facebookImage)
        
        
//        let logInButton = TWTRLogInButton { (session, error) in
//            // play with Twitter session
//            
//        }
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)
        
//        self.usernameTextField.returnKeyType = .Next
//        self.passwordTextField.returnKeyType = .Done
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
//        self.usernameTextField.becomeFirstResponder()

        if PFUser.currentUser() != nil {
            
            let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
            self.presentViewController(mainNav!, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: Button Actions
    
    @IBAction func loginAction(sender: UIButton) {
        
    }
    
    @IBAction func signupAction(sender: UIButton) {
        
    }

//    @IBAction func facebookAction(sender: FBSDKLoginButton) {
//        if PFUser.currentUser() != nil {
//                let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
//                self.presentViewController(mainNav!, animated: true, completion: nil)
//        } else {
//            ParseHelper.loginWithFacebook({ (user, error) -> Void in
//                if user == nil {
//                    println("Uh oh. The user cancelled the Facebook login.")
//                } else if user!.isNew == true {
//                    
//                    MixpanelHelper.trackFacebookSignup()
//                    
//                    ParseHelper.getUserInformationFromFB()
//                    
//                    println("User signed up and logged in through Facebook!")
//                    let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
//                    self.presentViewController(mainNav!, animated: true, completion: nil)
//                } else {
//                    println("User logged in through Facebook!")
//                    
//                    MixpanelHelper.trackFacebookLogin()
//                    ParseHelper.getUserInformationFromFB()
//                    
//                    let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
//                    self.presentViewController(mainNav!, animated: true, completion: nil)
//                }
//            })
//        }
//    }
    
//    @IBAction func twitterAction(sender: UIButton) {
//        
//    }
    
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
