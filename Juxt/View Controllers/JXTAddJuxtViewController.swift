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
//
//    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var nextBottomSpace: NSLayoutConstraint! // Default bottom space = 20
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var uploadActivityIndicator: UIActivityIndicatorView!
    
    var photoTakingHelper: PhotoTakingHelper?
    var keyboardNotificationHandler: KeyboardHelper?

    weak var originalVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 5.0
        titleTextView.becomeFirstResponder()
        
        titleTextView.returnKeyType = .Next
        titleTextView.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        
        keyboardNotificationHandler = KeyboardHelper(view: self.view)
        
        keyboardNotificationHandler!.keyboardWillShowHandler = { height in
            UIView.animateWithDuration(0.3) {
                self.descriptionHeight.constant -= height
                self.nextBottomSpace.constant = 20
//                self.view.layoutIfNeeded()
            }
        }
        
        keyboardNotificationHandler!.keyboardWillShowHandler = { height in
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

    @IBAction func takePictureButtonTapped(sender: UIButton) {
         
        if titleTextView.text == "" || titleTextView.text == nil {
            let alert = UIAlertView()
            alert.title = "Add a title"
            alert.message = "Show the world what you're doing"
            alert.addButtonWithTitle("Dismiss")
            alert.show()
            return
        }
        uploadActivityIndicator.startAnimating()

        
        // Upload juxt
        let juxt = Juxt()
        juxt.title = self.titleTextView.text
        juxt.date = NSDate()
        self.photoTakingHelper = PhotoTakingHelper(viewController: self, juxt: juxt, cameraOnly: true, returnHome: true/*, cancelButtonHidden: true, addPhotoCancelButton: true*/)
    }

    @IBAction func dismissButtonTapped(sender: UIBarButtonItem) {
        
        MixpanelHelper.trackCancelAtCreateProject()
        titleTextView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
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
