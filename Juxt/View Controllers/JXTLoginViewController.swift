//
//  JXTLoginViewController.swift
//  Juxt
//
//  Created by Justin Yu on 8/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import ConvenienceKit
import Parse

class JXTLoginViewController: UIViewController {

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var keyboardNotificationHandler: KeyboardHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameTextField.returnKeyType = .Next
        self.passwordTextField.returnKeyType = .Done
        passwordTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        self.usernameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }

    @IBAction func cancelAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneAction(sender: UIButton) {
        
        if self.usernameTextField.text == "" || self.usernameTextField.text == nil {
            let alertController = UIAlertController(title: "Username Missing", message: "Enter your username to login.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if self.passwordTextField.text == "" || self.passwordTextField.text == nil {
            let alertController = UIAlertController(title: "Password Missing", message: "Enter your password to login.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) { (user, error) -> Void in
            if error != nil {
                print("\(error)")
                
                // Display alert
                
                let alertController = UIAlertController(title: "Username/Password Invalid", message: "The username/password you have entered is not correct.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else if user != nil {

                let mainNav = self.storyboard?.instantiateViewControllerWithIdentifier("MainNav") as? UINavigationController
                self.presentViewController(mainNav!, animated: true, completion: nil)
                
            }
        }
        
    }
    
}

extension JXTLoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.doneAction(UIButton())
        return false
    }
}
