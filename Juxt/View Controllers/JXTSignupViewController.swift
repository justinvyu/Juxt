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

enum ErrorType {
    case UsernameTooShort
    case Missing
    case NotMatching
}

class JXTSignupViewController: UIViewController {

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var profilePicture: UIButton?
    var profileLabel: UILabel?
    var eulaTextView: UITextView?
    
    var errorLabel: UILabel?
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var state: Int! {
        didSet {
            switch state {
            case 0: // username password
                self.contentScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
                self.backButton.hidden = true
                self.cancelButton.hidden = false
            case 1: // profile picture
                if self.checkValidSignup() == true {
                    self.errorLabel?.hidden = true
                    self.contentScrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: true)
                    self.backButton.hidden = false
                    self.cancelButton.hidden = true
                    self.profilePicture?.hidden = false
                    self.profileLabel?.hidden = false
                } else {
                    self.state = 0
                }
            case 2: // license agreement
                self.contentScrollView.setContentOffset(CGPointMake(2 * self.view.frame.size.width, 0), animated: true)
            case 3:
                println("done")
            default:
                println("invalid state")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.returnKeyType = .Next
        self.passwordTextField.returnKeyType = .Done
        
        self.state = 0
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupScrollView()
        
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
        
        usernameTextField.becomeFirstResponder()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let temp = self.state
        self.state = temp
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profilePicture?.center = self.contentScrollView.center
        profilePicture?.center.y = self.passwordTextField.center.y - 10
        profilePicture?.center.x += self.view.frame.size.width
        
        profileLabel?.center = self.contentScrollView.center
        profileLabel?.center.y = self.passwordTextField.center.y
        profileLabel?.center.y += (40 + 10)
        profileLabel?.center.x += self.view.frame.size.width
        
    }
    
    func checkValidSignup() -> Bool {
        
        if usernameTextField.text == "" || usernameTextField.text == nil ||
            passwordTextField.text == "" || passwordTextField.text == nil ||
        confirmPasswordTextField.text == "" {
            self.showError(.Missing)
            return false
        }
        
        if count(usernameTextField.text) < 6 {
            self.showError(.UsernameTooShort)
            return false
        }
        
        if passwordTextField.text != confirmPasswordTextField.text {
            self.showError(.NotMatching)
            return false
        }
        
        return true
    }
    
    func showError(errorType: ErrorType) {
        
        if self.errorLabel == nil {
            self.errorLabel = UILabel(frame: CGRectMake(20, self.nextButton.frame.origin.y - 70, self.view.frame.size.width - 40, 50))
            self.errorLabel?.textColor = UIColor.whiteColor()
            self.errorLabel?.textAlignment = .Center
            
            self.view.addSubview(errorLabel!)
        }
        
        if errorType == .UsernameTooShort {
            self.errorLabel?.text = "Your username should be 6+ characters."
        } else if errorType == .Missing {
            self.errorLabel?.text = "One or more text fields are empty."
        } else if errorType == .NotMatching {
            self.errorLabel?.text = "The passwords you provided to not match."
        }
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextAction(sender: UIButton) {
        self.state = self.state == 3 ? self.state : self.state + 1
    }
    
    @IBAction func backAction(sender: UIButton) {
        self.state = self.state == 0 ? self.state : self.state - 1
    }
    func setupScrollView() {
        self.contentScrollView.contentSize = CGSizeMake(3 * self.view.frame.size.width, self.contentScrollView.frame.size.height)
        
        // Profile Image
        
        profilePicture = UIButton.buttonWithType(.Custom) as? UIButton
        profilePicture?.setImage(UIImage(named: "splash"), forState: .Normal)
        profilePicture?.imageView?.contentMode = .ScaleAspectFill
        profilePicture?.frame = CGRectMake(0, 0, 80, 80)
        profilePicture?.layer.cornerRadius = 16.0
        profilePicture?.clipsToBounds = true
        profilePicture?.addTarget(self, action: "setProfilePicture", forControlEvents: .TouchUpInside)
        self.contentScrollView.addSubview(profilePicture!)
        self.profilePicture?.hidden = true
        
        let profileLabel = UILabel(frame: CGRectMake(0, 0, 200, 44))
        profileLabel.text = "tap to your own profile picture"
        profileLabel.textAlignment = .Center
        profileLabel.font = UIFont.systemFontOfSize(15.0)
        profileLabel.textColor = UIColor.whiteColor()
        self.contentScrollView.addSubview(profileLabel)
        self.profileLabel = profileLabel
        self.profileLabel?.hidden = true
        
        self.eulaTextView = UITextView(frame: CGRectMake(0, 0, self.view.frame.size.with - 20, self.view.frame.size.height - 10))
        eulaTextView.text =
    }
    
    func setProfilePicture() {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        self.photoTakingHelper = PhotoTakingHelper(viewController: self) { image in
            let resized = ImageHelper.scaleImage(image!, width: 300.0)
            self.profilePicture?.setImage(resized, forState: .Normal)
        }
    }
    
}
