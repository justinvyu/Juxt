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
    case UsernameAlreadyExists
}

class JXTSignupViewController: UIViewController {

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var keyboardNotificationHandler: KeyboardHelper?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eulaTextView: UITextView!
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!

    var profileImage: UIImage!
    var errorLabel: UILabel?
    
    @IBOutlet weak var nextButton: JYProgressButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    var state: Int! {
        didSet {
            switch state {
            case 0: // username password
                backButton.hidden = true
                cancelButton.hidden = false
                nextButton.setTitle("next", forState: .Normal)

                profilePictureButton.hidden = true
                previewImageView.hidden = true
//                instructionLabel.hidden = true

                setTextFieldsHidden(false)
            case 1: // profile picture
                if checkValidSignup() {
                    errorLabel?.text = ""
                    
                    cancelButton.hidden = true
                    backButton.hidden = false

                    profilePictureButton.hidden = false
                    previewImageView.hidden = false
//                    instructionLabel.hidden = false
                    nextButton.setTitle("next", forState: .Normal)

                    eulaTextView.hidden = true
                    setTextFieldsHidden(true)
                } else {
                    self.state = 0
                }
            case 2: // license agreement
                profilePictureButton.hidden = true
                previewImageView.hidden = true
//                instructionLabel.hidden = true
                nextButton.setTitle("agree", forState: .Normal)
                eulaTextView.hidden = false

            case 3:
//                nextButton.startAnimating()
                signupUser()
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

        // Set TextView EULA text
        let path = NSBundle.mainBundle().pathForResource("eula", ofType: "txt")
        eulaTextView.text = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)

        let resized = ImageHelper.scaleImage(UIImage(named: "splash")!, width: 300.0)
        profileImage = resized
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Reset state (maybe not necessary)
        let temp = self.state
        self.state = temp

        // Set Text View Options
        eulaTextView.font = UIFont.systemFontOfSize(15)
        eulaTextView.textColor = UIColor.whiteColor()

        // Prof. Picture
        profilePictureButton.layer.cornerRadius = 8.0
        profilePictureButton.clipsToBounds = true
        previewImageView.layer.cornerRadius = 8.0
        previewImageView.clipsToBounds = true
        previewImageView.contentMode = .ScaleAspectFill
        
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

        if state == 0 {
            usernameTextField.becomeFirstResponder()
        }
    }

    override func viewWillLayoutSubviews() {
        eulaTextView.contentOffset = CGPointMake(0, 0)
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

        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()

        if self.errorLabel == nil {
            errorLabel = UILabel(frame: CGRectMake(20, self.nextButton.frame.origin.y - 70, self.view.frame.size.width - 40, 50))
            errorLabel?.textColor = UIColor.whiteColor()
            errorLabel?.textAlignment = .Center
            errorLabel?.numberOfLines = 0

            self.view.addSubview(errorLabel!)
        }
        
        if errorType == .UsernameTooShort {
            self.errorLabel?.text = "Your username should be 6+\ncharacters."
        } else if errorType == .Missing {
            self.errorLabel?.text = "One or more text fields are empty."
        } else if errorType == .NotMatching {
            self.errorLabel?.text = "The passwords you provided\ndo not match."
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

    @IBAction func setProfilePicture() {

        state = 1

        self.photoTakingHelper = PhotoTakingHelper(viewController: self) { image in
            let resized = ImageHelper.scaleImage(image!, width: 300.0)
            self.profileImage = resized
            self.previewImageView.image = image
        }
    }

    func setTextFieldsHidden(hidden: Bool) {
        usernameTextField.hidden = hidden
        passwordTextField.hidden = hidden
        confirmPasswordTextField.hidden = hidden

        if hidden {
            confirmPasswordTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            usernameTextField.resignFirstResponder()
        }

    }

    func signupUser() {
        if let username = usernameTextField.text, password = passwordTextField.text,
            profileImage = profileImage {
            ParseHelper.createUser(username, password: password, profilePicture: profileImage) { success, error in
                if success {
                    PFUser.logInWithUsernameInBackground(username, password: password) { user, error -> Void in
                        if error != nil {
                            print("\(error)")

                            // Display alert

                            self.displayErrorAlert("Unable to Login", desc: "")
                        } else if user != nil {

                            let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                            self.presentViewController(mainNav!, animated: true, completion: nil)
                        }
//                        self.nextButton.stopAnimating()
                    }
                } else {
                    self.displayErrorAlert("Unable to Create Account", desc: "Try a different username")
                }
//                self.nextButton.stopAnimating()
            }
        }
    }

    func displayErrorAlert(text: String, desc: String) {
        let alertController = UIAlertController(title: text, message: desc, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
