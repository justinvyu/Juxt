//
//  JXTCompareView.swift
//  Juxt
//
//  Created by Justin Yu on 7/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import FXBlurView

protocol JXTCompareViewDelegate {
    func compareViewDidCancel(button: UIButton)
    func compareButtonWasPressedWithImages(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage)
    func shareButtonWasPressed(button: UIButton)
    func saveToCameraRoll(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage)
}

class JXTCompareView: UIView {

    var leftCompareView: JXTImageGalleryScrollView?
    var rightCompareView: JXTImageGalleryScrollView?
    var cancelButton: UIButton?
    var compareLabel: UILabel?
    var compareButton: UIButton?
    var whiteBackgroundView: UIView?
    var separatorView: UIView?
    var topDarkenView: UIView?
    var bottomDarkenView: UIView?
    var saveButton: UIButton?
    var bottomBar: UIView?
    var facebookButton: UIButton?
    var twitterButton: UIButton?
    
    var shareButton: JYProgressButton?
    
    //    var topBlurView: FXBlurView?
//    var bottomBlurView: FXBlurView?
    var topView: UIView?
    var bottomView: UIView?
    
    var delegate: JXTCompareViewDelegate?
    
    init(frame: CGRect, photos: [Photo]) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = frame
//        let blurView = FXBlurView()
//        blurView.frame = self.frame
//        blurView.tintColor = UIColor.blackColor()
//        blurView.blurEnabled = true
        
        self.addSubview(blurView)
        
        compareLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        compareLabel?.center = self.center
        compareLabel?.frame.origin.y = 20
        compareLabel?.text = "share a side by side"
        compareLabel?.font = UIFont.systemFontOfSize(18.0)
        compareLabel?.textAlignment = .Center
        compareLabel?.textColor = UIColor.whiteColor()
        compareLabel?.layer.zPosition = 4
        self.addSubview(compareLabel!)

        cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
        cancelButton?.frame = CGRectMake(5, 20, 44, 44)
        cancelButton?.tintColor = JXTConstants.defaultBlueColor()
        cancelButton?.setImage(UIImage(named: "cancel"), forState: .Normal)
        cancelButton?.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        cancelButton?.addTarget(self, action: Selector("cancelButtonPressed:"), forControlEvents: .TouchUpInside)
        cancelButton?.layer.zPosition = 4
        self.addSubview(cancelButton!)
        
        let imageSize: CGSize = CGSizeMake(frame.size.width / 2 - 20, frame.size.width - 60)
        let imagePadding: CGFloat = 10.0
        
        topView = UIView()
        topView?.backgroundColor = UIColor.whiteColor()
        
        topView?.frame = CGRectMake(0, self.center.y - imageSize.height / 2 - imagePadding - 2, self.frame.size.width, 2)
        
        whiteBackgroundView = UIView(frame: CGRectMake(16 /* 20 (offset) - 4 (border width)*/, topView!.frame.origin.y + topView!.frame.size.height + imagePadding - 4, frame.size.width - 32, imageSize.height + 8))
        whiteBackgroundView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(whiteBackgroundView!)
        
        separatorView = UIView(frame: CGRectMake(frame.size.width / 2 - 2, topView!.frame.origin.y + topView!.frame.size.height + imagePadding - 4, 4, imageSize.height + 8))
        separatorView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(separatorView!)
        
        leftCompareView = JXTImageGalleryScrollView()
        leftCompareView?.frame = CGRectMake(20, topView!.frame.origin.y + topView!.frame.size.height + imagePadding, self.frame.size.width / 2, imageSize.height+20)
        leftCompareView?.direction = .Vertical
        leftCompareView?.imageSize = imageSize
        leftCompareView?.photos = photos
        leftCompareView?.clipsToBounds = false
        leftCompareView?.pagingEnabled = true
        self.addSubview(leftCompareView!)
        
        rightCompareView = JXTImageGalleryScrollView()
        rightCompareView?.frame = CGRectMake(self.frame.size.width / 2, topView!.frame.origin.y + topView!.frame.size.height + imagePadding, self.frame.size.width / 2, imageSize.height+20)
        rightCompareView?.direction = .Vertical
        rightCompareView?.imageSize = imageSize
        rightCompareView?.photos = photos.reverse()
        rightCompareView?.clipsToBounds = false
        rightCompareView?.pagingEnabled = true
        self.addSubview(rightCompareView!)
        
        bottomView = UIView()
        bottomView?.backgroundColor = UIColor.whiteColor()
        bottomView?.frame = CGRectMake(0, leftCompareView!.frame.origin.y + imageSize.height + imagePadding + 2, self.frame.size.width, 2)
//        self.addSubview(bottomView!)
        
        self.bringSubviewToFront(separatorView!)
        
//        compareButton = UIButton(frame: CGRectMake(0, 0, 60, 60))
//        compareButton?.center = self.center
//        compareButton?.setImage(UIImage(named: "check"), forState: .Normal)
//        compareButton?.addTarget(self, action: "compare:", forControlEvents: .TouchUpInside)
//        compareButton?.backgroundColor = JXTConstants.defaultBlueColor()
//        compareButton?.layer.cornerRadius = 30
//        self.addSubview(compareButton!)
        
        topDarkenView = UIView(frame: CGRectMake(0, 0, frame.size.width, topView!.frame.origin.y))
        topDarkenView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.addSubview(topDarkenView!)
        
        bottomDarkenView = UIView(frame: CGRectMake(0, bottomView!.frame.origin.y + 2, frame.size.width, frame.size.height - bottomView!.frame.origin.y - 2))
        bottomDarkenView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.addSubview(bottomDarkenView!)
        
        bottomBar = UIView(frame: CGRectMake(0, frame.size.height - 60, frame.size.width, 60))
        bottomBar?.backgroundColor = JXTConstants.defaultBlueColor().colorWithAlphaComponent(0.9)
        self.addSubview(bottomBar!)
        
        saveButton = UIButton(frame: CGRectMake(bottomBar!.frame.size.width / 3 - 44, 5, 44, 44))
        saveButton?.setImage(UIImage(named: "download"), forState: .Normal)
        saveButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
//        saveButton?.frame.origin.x = self.frame.width - 53
        bottomBar?.addSubview(saveButton!)
        saveButton?.addTarget(self, action: "saveToCameraRoll:", forControlEvents: .TouchUpInside)
        
        facebookButton = UIButton(frame: CGRectMake(0, 5, 44, 44))
        facebookButton?.setImage(UIImage(named: "facebook"), forState: .Normal)
        facebookButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        bottomBar?.addSubview(facebookButton!)
        facebookButton?.center.x = bottomBar!.center.x
        facebookButton?.addTarget(self, action: "compareFacebook:", forControlEvents: .TouchUpInside)
        
        twitterButton = UIButton(frame: CGRectMake(2 * bottomBar!.frame.size.width / 3, 5, 44, 44))
        twitterButton?.setImage(UIImage(named: "twitter"), forState: .Normal)
        twitterButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        bottomBar?.addSubview(twitterButton!)
        
        self.bringSubviewToFront(compareLabel!)
        self.bringSubviewToFront(cancelButton!)
        self.bringSubviewToFront(saveButton!)
        self.bringSubviewToFront(facebookButton!)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cancelButtonPressed(button: UIButton) {
        self.delegate?.compareViewDidCancel(button)
    }
    
    func getCurrentLeftGalleryImage() -> UIImage {

        let imageSize: CGSize = CGSizeMake(frame.size.width / 2 - 20, frame.size.width - 60)
        
        let leftImageIndex = Int(floor(leftCompareView!.contentOffset.y / imageSize.height))
        let leftImage = leftCompareView!.images![leftImageIndex]
        
        return leftImage
    }
    
    func getCurrentRightGalleryImage() -> UIImage {
        let imageSize: CGSize = CGSizeMake(frame.size.width / 2 - 20, frame.size.width - 60)

        let rightImageIndex = Int(floor(rightCompareView!.contentOffset.y / imageSize.height))
        let rightImage = rightCompareView!.images![rightImageIndex]
        
        return rightImage
    }
    
    func compareFacebook(button: UIButton) {
        button.enabled = false
        
        self.delegate?.compareButtonWasPressedWithImages(self, firstImage: self.getCurrentLeftGalleryImage(), secondImage: self.getCurrentRightGalleryImage())
        
        button.enabled = true
    }
    
    func saveToCameraRoll(button: UIButton) {
        
//        UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil);
        self.delegate?.saveToCameraRoll(self, firstImage: self.getCurrentLeftGalleryImage(), secondImage: self.getCurrentRightGalleryImage())
    }
    
    func shareButtonPressed(button: JYProgressButton) {
        self.shareButton?.startAnimating()
        self.delegate?.shareButtonWasPressed(button)
    }
}

extension JXTCompareView: UIScrollViewDelegate {
    
    
}
