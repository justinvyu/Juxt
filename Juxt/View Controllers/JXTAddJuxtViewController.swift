//
//  JXTAddJuxtViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import ConvenienceKit

class JXTAddJuxtViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var nextBottomSpace: NSLayoutConstraint! // Default bottom space = 20
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    var keyboardNotificationHandler : KeyboardNotificationHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 5.0
        titleTextField.becomeFirstResponder()
        
        titleTextField.returnKeyType = .Next
        descriptionTextView.delegate = self
        titleTextField.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3) {
                self.descriptionHeight.constant -= height
                self.nextBottomSpace.constant = 20
//                self.view.layoutIfNeeded()
            }
        }
        
        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in
            UIView.animateWithDuration(0.3) {
                self.descriptionHeight.constant += height
                self.nextBottomSpace.constant = height + 10
//                self.view.layoutIfNeeded()
            }
        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func takePictureButtonTapped(sender: UIButton) {
        
        if titleTextField.text == "" || titleTextField == nil {
            let alert = UIAlertView()
            alert.title = "Add a title"
            alert.message = "Show the world what you're doing"
            alert.addButtonWithTitle("Dismiss")
            alert.show()
            return
        }
        
        // Upload juxt
        let juxt = Juxt()
        juxt.title = self.titleTextField.text
        juxt.desc = self.descriptionTextView.text
        juxt.date = NSDate()
        sender.enabled = false
        juxt.uploadJuxt { (finished, error) -> Void in
            if error != nil {
                println("error: \(error?.localizedDescription)")
            }
            self.titleTextField.resignFirstResponder()
            self.descriptionTextView.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func dismissButtonTapped(sender: UIBarButtonItem) {
        
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension JXTAddJuxtViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        descriptionTextView.becomeFirstResponder()
        
        return false
        
    }
    
}

extension JXTAddJuxtViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
}
