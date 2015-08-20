//
//  JXTSignupViewController.swift
//  Juxt
//
//  Created by Justin Yu on 8/18/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import ConvenienceKit
import Parse

class JXTSignupViewController: UIViewController {

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    var profilePicture: UIButton?
    var profileLabel: UILabel?
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.returnKeyType = .Next
        self.passwordTextField.returnKeyType = .Done
        
        self.setupScrollView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        keyboardNotificationHandler?.keyboardWillBeShownHandler = { height in
            
            UIView.animateWithDuration(0.25) {
                self.bottomSpaceConstraint.constant = -height
                self.view.layoutIfNeeded()
            }
            
        }
        keyboardNotificationHandler?.keyboardWillBeHiddenHandler = { height in
            
            UIView.animateWithDuration(0.25) {
                self.bottomSpaceConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.usernameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }

    override func viewWillLayoutSubviews() {
        profilePicture?.center = self.contentScrollView.center
        profilePicture?.center.y = self.passwordTextField.center.y - 10
        profilePicture?.center.x += self.view.frame.size.width
        
        profileLabel?.center = self.contentScrollView.center
        profileLabel?.center.y = self.passwordTextField.center.y
        profileLabel?.center.y += (40 + 10)
        profileLabel?.center.x += self.view.frame.size.width
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextAction(sender: UIButton) {
        self.contentScrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: true)
    }
    
    func setupScrollView() {
        self.contentScrollView.contentSize = CGSizeMake(3 * self.view.frame.size.width, self.contentScrollView.frame.size.height)
        
        // Profile Image
        
        profilePicture = UIButton.buttonWithType(.Custom) as? UIButton
        profilePicture?.setImage(UIImage(named: "splash"), forState: .Normal)
        profilePicture?.contentMode = .ScaleAspectFill
        profilePicture?.frame = CGRectMake(0, 0, 80, 80)
        profilePicture?.layer.cornerRadius = 16.0
        profilePicture?.clipsToBounds = true
        profilePicture?.addTarget(self, action: "setProfilePicture", forControlEvents: .TouchUpInside)
        self.contentScrollView.addSubview(profilePicture!)
        
        let profileLabel = UILabel(frame: CGRectMake(0, 0, 200, 44))
        profileLabel.text = "add your own profile picture"
        profileLabel.textAlignment = .Center
        profileLabel.font = UIFont.systemFontOfSize(15.0)
        profileLabel.textColor = UIColor.whiteColor()
        self.contentScrollView.addSubview(profileLabel)
        self.profileLabel = profileLabel
    }
    
    func setProfilePicture() {
        
    }
    
}
