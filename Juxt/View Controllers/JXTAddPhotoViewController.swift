//
//  JXTAddPhotoViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import ConvenienceKit
import Parse

protocol JXTAddPhotoViewControllerDelegate {
    
    func retakePicture()

}

class JXTAddPhotoViewController: UIViewController {

    var delegate: JXTAddPhotoViewControllerDelegate?
    var juxt: Juxt?
    var photoView: UIImageView?
    var confirmLabel: UILabel?
    var nextButton: UIButton?
    var takeAgainButton: UIButton?
    var doneButton: JYProgressButton?
//    var uploadActivityIndicator: UIActivityIndicatorView?
    var titleLabel: UILabel?
    var titleTextField: UITextField?
    var scrollView: UIScrollView?
    var image: UIImage?
    var keyboardNotificationHandler: KeyboardNotificationHandler?
//    var addPhotoCancelButtonHidden: Bool? = false
    var returnHome: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "add a photo"

        self.view.backgroundColor = UIColor.whiteColor()
        
        setupPhotoUI()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
//        keyboardNotificationHandler?.keyboardWillBeHiddenHandler = { (height: CGFloat) in
//            println(height)
//            UIView.animateWithDuration(0.3, animations: { () -> Void in
//                self.doneButton?.frame.origin.y += height
//            })
//        }
        
        keyboardNotificationHandler?.keyboardWillBeShownHandler = { (height: CGFloat) in
            print(height)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.doneButton?.frame.origin.y -= height
            })
            self.keyboardNotificationHandler?.keyboardWillBeShownHandler = nil
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
//        if self.addPhotoCancelButtonHidden == false {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: Selector("dismissToJuxt"))
//        }
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
    }
    
    // MARK: Helper Funcs
    
    func setupPhotoUI() {
        
        self.view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(white: 0.96, alpha: 1.0)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        scrollView?.scrollEnabled = true
        scrollView?.pagingEnabled = true
        scrollView?.directionalLockEnabled = true
        scrollView?.contentSize = CGSizeMake(self.view.frame.size.width * 2, scrollView!.frame.size.height - 20 - self.navigationController!.navigationBar.frame.size.height)
        scrollView?.bounces = false
        scrollView?.delegate = self
        self.view.addSubview(scrollView!)
        
        photoView = UIImageView(frame: CGRectMake(20, 10, scrollView!.frame.size.width - 40, scrollView!.frame.size.width - 40))
        photoView?.image = self.image
        photoView?.layer.cornerRadius = 5.0
        photoView?.contentMode = .ScaleAspectFill
        photoView?.clipsToBounds = true
        scrollView!.addSubview(photoView!)
        
        confirmLabel = UILabel(frame: CGRectMake(30, 15 + photoView!.frame.size.height, scrollView!.frame.size.width - 60, 44))
        confirmLabel?.text = "are you okay with this photo?"
        confirmLabel?.textAlignment = .Center
        confirmLabel?.font = UIFont.systemFontOfSize(18.0)
        confirmLabel?.textColor = UIColor(white: 0.30, alpha: 1.0)
        scrollView!.addSubview(confirmLabel!)
        
        takeAgainButton = UIButton(frame: CGRectMake(30, self.view.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 44 - 15 - 20, scrollView!.frame.size.width - 60, 44))
        takeAgainButton?.layer.cornerRadius = 5.0
        takeAgainButton?.layer.borderColor = JXTConstants.defaultBlueColor().CGColor
        takeAgainButton?.layer.borderWidth = 1.0
        takeAgainButton?.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        takeAgainButton?.setTitleColor(JXTConstants.defaultBlueColor(), forState: .Normal)
        takeAgainButton?.setTitle("retake", forState: .Normal)
        takeAgainButton?.titleLabel?.font = UIFont.systemFontOfSize(18.0)
        takeAgainButton?.addTarget(self, action: Selector("takeAgainButtonPressed:"), forControlEvents: .TouchUpInside)
        scrollView!.addSubview(takeAgainButton!)
        
        nextButton = UIButton(frame: CGRectMake(30, takeAgainButton!.frame.origin.y - 44 - 15, scrollView!.frame.size.width - 60, 44))
        nextButton?.layer.cornerRadius = 5.0
        nextButton?.layer.borderColor = JXTConstants.defaultBlueColor().CGColor
        nextButton?.layer.borderWidth = 1.0
        nextButton?.backgroundColor = JXTConstants.defaultBlueColor()
        nextButton?.titleLabel?.textColor = UIColor(white: 0.96, alpha: 1.0)
        nextButton?.setTitle("next", forState: .Normal)
        nextButton?.titleLabel?.font = UIFont.systemFontOfSize(18.0)
        
        nextButton?.addTarget(self, action: Selector("nextButtonPressed:"), forControlEvents: .TouchUpInside)
        scrollView!.addSubview(nextButton!)
        
        let secondPageX = self.view.frame.size.width
        
        titleLabel = UILabel(frame: CGRectMake(secondPageX + 10, 20, self.view.frame.size.width - 20, 44))
        titleLabel?.text = "what is it?"
        titleLabel?.textAlignment = .Center
        titleLabel?.font = UIFont.systemFontOfSize(18.0)
        titleLabel?.textColor = UIColor.lightGrayColor()
        scrollView!.addSubview(titleLabel!)
        
        titleTextField = UITextField(frame: CGRectMake(secondPageX + 20, 20 + 44, self.view.frame.size.width - 40, 44))
        titleTextField?.textAlignment = .Center
        titleTextField?.font = UIFont.systemFontOfSize(18.0)
        scrollView!.addSubview(titleTextField!)
        
        doneButton = JYProgressButton(frame: CGRectMake(secondPageX + 20, self.view.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 44 - 20 - 20, self.view.frame.size.width - 40, 44), animating: false)
        doneButton?.backgroundColor = JXTConstants.defaultBlueColor()
        doneButton?.setTitle("share", forState: .Normal)
        doneButton?.layer.cornerRadius = 5.0
        doneButton?.titleLabel?.textColor = UIColor.whiteColor()
        doneButton?.titleLabel?.font = UIFont.systemFontOfSize(18)
        doneButton?.addTarget(self, action: Selector("doneButtonPressed:"), forControlEvents: .TouchUpInside)
        scrollView!.addSubview(doneButton!)
        
//        uploadActivityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
//        uploadActivityIndicator?.center = doneButton!.center
//        uploadActivityIndicator?.frame.origin.y = doneButton!.frame.size.width - 30
//        uploadActivityIndicator?.hidesWhenStopped = true
//        doneButton!.addSubview(uploadActivityIndicator!)
    }
    
    func takeAgainButtonPressed(button: UIButton) {
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            self.delegate?.retakePicture()
        })
        
    }
    
    func nextButtonPressed(button: UIButton) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollView?.contentOffset.x += self.view.frame.size.width
            self.titleTextField?.becomeFirstResponder()
        })
    }
    
    func dismissToJuxt() {

        MixpanelHelper.trackCancelAtDescribeImage()
        self.titleTextField?.resignFirstResponder()
        if returnHome == true {
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func doneButtonPressed(button: JYProgressButton) {
        
        if let juxt = juxt, titleTextField = titleTextField, image = image {
            if titleTextField.text == "" || titleTextField.text == nil {
                let alert = UIAlertView()
                alert.title = "Add a title"
                alert.message = "Tell the world what this picture is about"
                alert.addButtonWithTitle("Dismiss")
                alert.show()
                return
            }
            
            button.enabled = false
            navigationItem.leftBarButtonItem?.enabled = false
            scrollView?.scrollEnabled = false

            button.startAnimating()

            juxt.uploadJuxt({ (finished, error) -> Void in
                if error != nil {
                    print("\(error)")
                } else {
                    juxt.toggleLikePost(PFUser.currentUser()!)
                    if juxt.photos?.count == 0 {
                        MixpanelHelper.trackCreatePost()
                    }
                
                    let photo = Photo()
                    photo.title = titleTextField.text
                    photo.fromJuxt = juxt
                    photo.image = ImageHelper.scaleImage(image, width: 640)
                    
                    photo.uploadPhoto { (finished, error) -> Void in
                        
                        if finished {
                            self.doneButton?.stopAnimating()
                            //                    self.uploadActivityIndicator?.stopAnimating()
                            //self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                            MixpanelHelper.trackAddPhoto()
                            self.dismissToJuxt()
                        } else {
                            self.navigationItem.leftBarButtonItem?.enabled = true
                            self.scrollView?.scrollEnabled = true
                            JXTConstants.displayErrorAlert(self, text: "Unable to Upload Photo", desc: "Try again later.")
                        }
                    }

                }
            })
        }
    }
}

extension JXTAddPhotoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset == CGPointMake(0, scrollView.contentOffset.y) {
            self.titleTextField?.resignFirstResponder()
        } else if scrollView.contentOffset == CGPointMake(self.view.frame.size.width, scrollView.contentOffset.y) {
            self.titleTextField?.becomeFirstResponder()
        }
    }
    
}