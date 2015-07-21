//
//  JXTAddPhotoViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class JXTAddPhotoViewController: UIViewController {

    var photoView: UIImageView?
    
    var confirmLabel: UILabel?
    var nextButton: UIButton?
    var takeAgainButton: UIButton?
    
    var doneButton: UIButton?
    
    var titleLabel: UILabel?
    var titleTextField: UITextField?
    
    var scrollView: UIScrollView?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "add a photo"

        self.view.backgroundColor = UIColor.whiteColor()
        
        setupPhotoUI()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: Selector("dismissToJuxt:"))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Funcs
    
    func setupPhotoUI() {
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        scrollView?.scrollEnabled = true
        scrollView?.pagingEnabled = true
        scrollView?.directionalLockEnabled = true
        scrollView?.contentSize = CGSizeMake(self.view.frame.size.width * 2, scrollView!.frame.size.height - 20 - self.navigationController!.navigationBar.frame.size.height)
        scrollView?.bounces = true
        self.view.addSubview(scrollView!)
        
        
        photoView = UIImageView(frame: CGRectMake(10, 10, scrollView!.frame.size.width - 20, scrollView!.frame.size.width - 20))
        photoView?.image = self.image
        photoView?.layer.cornerRadius = 5.0
        photoView?.contentMode = .ScaleAspectFill
        photoView?.clipsToBounds = true
        scrollView!.addSubview(photoView!)
        
        confirmLabel = UILabel(frame: CGRectMake(10, 20 + photoView!.frame.size.height, scrollView!.frame.size.width - 20, 44))
        confirmLabel?.text = "are you okay with this photo?"
        confirmLabel?.textAlignment = .Center
        confirmLabel?.font = JXTConstants.fontWithSize(18.0)
        scrollView!.addSubview(confirmLabel!)
        
        takeAgainButton = UIButton(frame: CGRectMake(20, self.view.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 44 - 20 - 20, scrollView!.frame.size.width - 40, 44))
        takeAgainButton?.layer.cornerRadius = 5.0
        takeAgainButton?.layer.borderColor = JXTConstants.defaultBlueColor().CGColor
        takeAgainButton?.layer.borderWidth = 1.0
        takeAgainButton?.backgroundColor = UIColor.whiteColor()
        takeAgainButton?.setTitleColor(JXTConstants.defaultBlueColor(), forState: .Normal)
        takeAgainButton?.setTitle("take again", forState: .Normal)
        takeAgainButton?.titleLabel?.font = JXTConstants.fontWithSize(18)
        scrollView!.addSubview(takeAgainButton!)
        
        nextButton = UIButton(frame: CGRectMake(20, takeAgainButton!.frame.origin.y - 44 - 20, scrollView!.frame.size.width - 40, 44))
        nextButton?.layer.cornerRadius = 5.0
        nextButton?.layer.borderColor = JXTConstants.defaultBlueColor().CGColor
        nextButton?.layer.borderWidth = 1.0
        nextButton?.backgroundColor = JXTConstants.defaultBlueColor()
        nextButton?.titleLabel?.textColor = UIColor.whiteColor()
        nextButton?.setTitle("next", forState: .Normal)
        nextButton?.titleLabel?.font = JXTConstants.fontWithSize(18)
        
        nextButton?.addTarget(self, action: Selector("nextButtonPressed:"), forControlEvents: .TouchUpInside)
        scrollView!.addSubview(nextButton!)
        
    }
    
    func nextButtonPressed(button: UIButton) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            scrollView?.contentOffset.x += self.view.frame.size.width
        })
    }
    
    func dismissToJuxt(button: UIButton) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
