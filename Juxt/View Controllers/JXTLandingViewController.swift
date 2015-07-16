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

class JXTLandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.wetAsphaltColor()
        
        let fbLogin = FBSDKLoginButton()
        fbLogin.frame = CGRectMake(0, 0, self.view.frame.width - 100, 40)
        fbLogin.center = self.view.center
        
        fbLogin.frame.origin.y += 50
        
        self.view.addSubview(fbLogin)
        
        let twitterLogin = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            // play with Twitter session
        })
        twitterLogin.frame = CGRectMake(0, 0, self.view.frame.width - 100, 40)
        twitterLogin.center = self.view.center
        
        twitterLogin.frame.origin.y += 100
        self.view.addSubview(twitterLogin)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
