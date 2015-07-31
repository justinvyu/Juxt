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
}

class JXTCompareView: UIView {

    var leftCompareView: JXTImageGalleryScrollView?
    var rightCompareView: JXTImageGalleryScrollView?
    var cancelButton: UIButton?
    var compareLabel: UILabel?
    var retryButton: UIButton?
    var compareButton: UIButton?
    var previewView: UIImageView?
    
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
        
        let lightBlur = UIBlurEffect(style: .ExtraLight)
        
        compareLabel = UILabel(frame: CGRectMake(0, 0, 100, 40))
        compareLabel?.center = self.center
        compareLabel?.frame.origin.y = 20
        compareLabel?.text = "compare"
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
        
        retryButton = UIButton(frame: CGRectMake(0, 20, 44, 44))
        retryButton?.setImage(UIImage(named: "retry"), forState: .Normal)
        retryButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        retryButton?.frame.origin.x = self.frame.width - 53
        self.addSubview(retryButton!)
        retryButton?.hidden = true
        retryButton?.addTarget(self, action: "showCompareUI", forControlEvents: .TouchUpInside)
        
        let imageSize: CGSize = CGSizeMake((frame.size.width / 2) - 20.0, (frame.size.width / 2) - 20.0)
        let imagePadding: CGFloat = 10.0
        
        topView = UIView()
        topView?.backgroundColor = UIColor.whiteColor()
//        topView?.frame = CGRectMake(0, imageSize.height + cancelButton!.frame.size.height + 2 * imagePadding, self.frame.size.width, 2)
        
        topView?.frame = CGRectMake(0, self.center.y - imageSize.height / 2 - imagePadding - 2, self.frame.size.width, 2)
        self.addSubview(topView!)
        
//        topBlurView = FXBlurView()
//        topBlurView?.blurEnabled = true
//        topBlurView?.tintColor = UIColor.whiteColor()
//        topBlurView?.frame = CGRectMake(0, 0, self.frame.size.width, imageSize.height + cancelButton!.frame.size.height + 2 * imagePadding)
//        self.addSubview(topBlurView!)
//        
//        leftCompareView = JXTImageGalleryScrollView(frame: CGRectMake(imagePadding, topBlurView!.frame.size.height/*imagePadding + 10 + cancelButton!.frame.size.height*/, frame.size.width / 2, 2 * imagePadding + imageSize.height/*frame.size.height - 10 - (5 * imagePadding)*/))
//        leftCompareView?.direction = .Vertical
//        leftCompareView?.imageSize = imageSize
//        leftCompareView?.photos = photos.reverse()
//        leftCompareView?.clipsToBounds = false
//        leftCompareView?.pagingEnabled = true
//        self.addSubview(leftCompareView!)
        
        leftCompareView = JXTImageGalleryScrollView()
        leftCompareView?.frame = CGRectMake(imagePadding, topView!.frame.origin.y + topView!.frame.size.height + imagePadding, self.frame.size.width / 2, imageSize.height+20)
        leftCompareView?.direction = .Vertical
        leftCompareView?.imageSize = imageSize
        leftCompareView?.photos = photos.reverse()
        leftCompareView?.clipsToBounds = false
        leftCompareView?.pagingEnabled = true
        self.addSubview(leftCompareView!)
        
//        rightCompareView = JXTImageGalleryScrollView(frame: CGRectMake(imagePadding + frame.size.width / 2, topBlurView!.frame.size.height/*imagePadding + 10 + cancelButton!.frame.size.height*/, frame.size.width / 2, 2 * imagePadding + imageSize.height/*frame.size.height - 10 - (5 * imagePadding)*/))
        rightCompareView = JXTImageGalleryScrollView()
        rightCompareView?.frame = CGRectMake(imagePadding + self.frame.size.width / 2, topView!.frame.origin.y + topView!.frame.size.height + imagePadding, self.frame.size.width / 2, imageSize.height+20)
        rightCompareView?.direction = .Vertical
        rightCompareView?.imageSize = imageSize
        rightCompareView?.photos = photos
        rightCompareView?.clipsToBounds = false
        rightCompareView?.pagingEnabled = true
        self.addSubview(rightCompareView!)
        
//        bottomBlurView = FXBlurView()
//        bottomBlurView?.tintColor = UIColor.whiteColor()
//        bottomBlurView?.frame = CGRectMake(0, leftCompareView!.frame.origin.y + imageSize.height + 2 * imagePadding, self.frame.size.width, self.frame.size.height - leftCompareView!.frame.size.height - imageSize.height)
//        self.addSubview(bottomBlurView!)
        
        bottomView = UIView()
        bottomView?.backgroundColor = UIColor.whiteColor()
        bottomView?.frame = CGRectMake(0, leftCompareView!.frame.origin.y + imageSize.height + imagePadding + 2, self.frame.size.width, 2)
        self.addSubview(bottomView!)
        
        compareButton = UIButton(frame: CGRectMake(0, 0, 60, 60))
        compareButton?.center = self.center
        compareButton?.setImage(UIImage(named: "check"), forState: .Normal)
        compareButton?.addTarget(self, action: "compare:", forControlEvents: .TouchUpInside)
        compareButton?.backgroundColor = JXTConstants.defaultBlueColor()
        compareButton?.layer.cornerRadius = 30
        self.addSubview(compareButton!)
        
        let button = JYProgressButton(frame: CGRectMake(0, 0, 200, 40), animating: false)
        button.center = self.center
        button.frame.origin.y = self.frame.size.height - 80
        button.layer.cornerRadius = 5.0
        button.setTitle("share", forState: .Normal)
        button.addTarget(self, action: "shareButtonPressed:", forControlEvents: .TouchUpInside)
        shareButton = button
        shareButton?.hidden = true
        self.addSubview(button)
        
        self.bringSubviewToFront(topView!)
        self.bringSubviewToFront(compareLabel!)
        self.bringSubviewToFront(cancelButton!)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cancelButtonPressed(button: UIButton) {
        self.delegate?.compareViewDidCancel(button)
    }
    
    func compare(button: UIButton) {
        button.enabled = false
        let imageSize: CGSize = CGSizeMake((frame.size.width / 2) - 20.0, (frame.size.width / 2) - 20.0)

        let leftImageIndex = Int(floor(leftCompareView!.contentOffset.y / imageSize.height))
        let leftImage = leftCompareView!.images![leftImageIndex]
        
        let rightImageIndex = Int(floor(rightCompareView!.contentOffset.y / imageSize.height))
        let rightImage = rightCompareView!.images![rightImageIndex]
        
        self.delegate?.compareButtonWasPressedWithImages(self, firstImage: leftImage, secondImage: rightImage)
        hideCompareUI()
        button.enabled = true
    }
    
    func shareButtonPressed(button: JYProgressButton) {
        self.shareButton?.startAnimating()
        self.delegate?.shareButtonWasPressed(button)
    }
    
    func showCompareUI() {
        leftCompareView?.hidden = false
        rightCompareView?.hidden = false
        topView?.hidden = false
        bottomView?.hidden = false
        
        retryButton?.hidden = true
        previewView?.hidden = true
        shareButton?.hidden = true
    }
    
    func hideCompareUI() {
        leftCompareView?.hidden = true
        rightCompareView?.hidden = true
        topView?.hidden = true
        bottomView?.hidden = true
        
        retryButton?.hidden = false
        previewView?.hidden = false
        shareButton?.hidden = false
        
//        shareButton = UIButton(frame: CGRectMake(0, 0, 150, 44))
//        shareButton?.backgroundColor = JXTConstants.defaultBlueColor()
//        shareButton?.layer.cornerRadius = 5.0
//        shareButton?.center = self.center
//        shareButton?.frame.origin.y = self.frame.size.height - 80
//        shareButton?.setTitle("share", forState: .Normal)
//        shareButton?.titleLabel?.textColor = UIColor.whiteColor()
//        self.addSubview(shareButton!)
    }
}

extension JXTCompareView: UIScrollViewDelegate {
    
    
}
