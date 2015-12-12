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
    var keyboardNotificationHandler: KeyboardHelper?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eulaTextView: UITextView!

    var profilePicture: UIButton?
    var profileLabel: UILabel?
    var errorLabel: UILabel?
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var state: Int! {
        didSet {
            switch state {
            case 0: // username password
                self.backButton.hidden = true
                self.cancelButton.hidden = false

                setTextFieldsHidden(false)
            case 1: // profile picture
                if self.checkValidSignup() == true {
                    self.errorLabel?.hidden = true
                    self.cancelButton.hidden = true
                    self.backButton.hidden = false

                    self.profilePicture?.hidden = false
                    self.profileLabel?.hidden = false
                    self.confirmPasswordTextField.resignFirstResponder()

                    self.eulaTextView.hidden = true
                    setTextFieldsHidden(true)
                } else {
                    self.state = 0
                }
            case 2: // license agreement
                self.eulaTextView?.hidden = false

            case 3:
                print("done")
            default:
                print("invalid state")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextField.returnKeyType = .Next
        self.passwordTextField.returnKeyType = .Done
        self.state = 0
        self.automaticallyAdjustsScrollViewInsets = false

        eulaTextView.textColor = UIColor.whiteColor()
        let path = NSBundle.mainBundle().pathForResource("eula", ofType: "txt")
        eulaTextView?.text = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let temp = self.state
        self.state = temp

        keyboardNotificationHandler = KeyboardHelper(view: self.view)
        keyboardNotificationHandler?.keyboardWillShowHandler = { height in

            UIView.animateWithDuration(0.25) {
                self.bottomSpaceConstraint.constant = -height
                self.view.layoutIfNeeded()
            }

        }
        keyboardNotificationHandler?.keyboardWillHideHandler = { height in

            UIView.animateWithDuration(0.25) {
                self.bottomSpaceConstraint.constant = 0
                self.view.layoutIfNeeded()
            }

        }

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func checkValidSignup() -> Bool {
        
        if usernameTextField.text == "" || usernameTextField.text == nil ||
            passwordTextField.text == "" || passwordTextField.text == nil ||
        confirmPasswordTextField.text == "" {
            self.showError(.Missing)
            return false
        }
        
        if usernameTextField.text!.characters.count < 6 {
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
    
    @IBAction func backAction(sender: UIButton) {
        state = state == 0 ? state : state - 1
    }

    @IBAction func nextAction(sender: UIButton) {
        state = state == 3 ? state : state + 1
    }

//    func setupScrollView() {
//
//        // Profile Image
//        
//        profilePicture = UIButton(type: .Custom) as? UIButton
//        profilePicture?.setImage(UIImage(named: "splash"), forState: .Normal)
//        profilePicture?.imageView?.contentMode = .ScaleAspectFill
//        profilePicture?.frame = CGRectMake(0, 0, 80, 80)
//        profilePicture?.layer.cornerRadius = 16.0
//        profilePicture?.clipsToBounds = true
//        profilePicture?.addTarget(self, action: "setProfilePicture", forControlEvents: .TouchUpInside)
////        self.contentScrollView.addSubview(profilePicture!)
//        self.profilePicture?.hidden = true
//        
//        let profileLabel = UILabel(frame: CGRectMake(0, 0, 300, 44))
//        profileLabel.text = "tap to your own profile picture"
//        profileLabel.textAlignment = .Center
//        profileLabel.font = UIFont.systemFontOfSize(15.0)
//        profileLabel.textColor = UIColor.whiteColor()
////        self.contentScrollView.addSubview(profileLabel)
//        self.profileLabel = profileLabel
//        self.profileLabel?.hidden = true
//        
//        self.eulaTextView = UITextView(frame: CGRectMake(0, 0, self.view.frame.size.width - 20, 0))
//        eulaTextView?.backgroundColor = UIColor.clearColor()
//        eulaTextView?.textColor = UIColor.whiteColor()
//        eulaTextView?.font = UIFont.systemFontOfSize(14.0)
//        eulaTextView?.editable = false
//        eulaTextView?.selectable = false
//        let file = "eula.txt"
//        
//        let path = NSBundle.mainBundle().pathForResource("eula", ofType: "txt")
//        eulaTextView?.text = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
//        eulaTextView?.hidden = true
//    }

    func setProfilePicture() {

        self.state = 1

        self.photoTakingHelper = PhotoTakingHelper(viewController: self) { image in
            let resized = ImageHelper.scaleImage(image!, width: 300.0)
            self.profilePicture?.setImage(resized, forState: .Normal)
        }
    }

    func setTextFieldsHidden(hidden: Bool) {
        usernameTextField.hidden = hidden
        passwordTextField.hidden = hidden
        confirmPasswordTextField.hidden = hidden
    }
    
}
