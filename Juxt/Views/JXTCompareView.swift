//
//  JXTCompareView.swift
//  Juxt
//
//  Created by Justin Yu on 7/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

protocol JXTCompareViewDelegate {
    func compareViewDidCancel(button: UIButton)
}

class JXTCompareView: UIView {

    var leftCompareView: JXTImageGalleryScrollView?
    var rightCompareView: JXTImageGalleryScrollView?
    var cancelButton: UIButton?
    var compareLabel: UILabel?
    
    var delegate: JXTCompareViewDelegate?
    
    init(frame: CGRect, photos: [Photo]) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = frame
        self.addSubview(blurView)
        
        compareLabel = UILabel(frame: CGRectMake(0, 0, 100, 40))
        compareLabel?.center = self.center
        compareLabel?.frame.origin.y = 20
        compareLabel?.text = "compare"
        compareLabel?.font = UIFont.systemFontOfSize(18.0)
        compareLabel?.textAlignment = .Center
        compareLabel?.textColor = UIColor.whiteColor()
        self.addSubview(compareLabel!)
        
        cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
        cancelButton?.frame = CGRectMake(5, 20, 44, 44)
        cancelButton?.tintColor = JXTConstants.defaultBlueColor()
        cancelButton?.setImage(UIImage(named: "cancel"), forState: .Normal)
        cancelButton?.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        cancelButton?.addTarget(self, action: Selector("cancelButtonPressed:"), forControlEvents: .TouchUpInside)
        self.addSubview(cancelButton!)
        
        let imageSize: CGSize = CGSizeMake((frame.size.width / 2) - 20.0, (frame.size.width / 2) - 20.0)
        let imagePadding: CGFloat = 10.0
        
        leftCompareView = JXTImageGalleryScrollView(frame: CGRectMake(imagePadding, imagePadding + 10 + cancelButton!.frame.size.height, frame.size.width / 2, frame.size.height - cancelButton!.frame.size.height - 10 - (5 * imagePadding)))
        leftCompareView?.direction = .Vertical
        leftCompareView?.imageSize = imageSize
        leftCompareView?.photos = photos
        leftCompareView?.clipsToBounds = true
        self.addSubview(leftCompareView!)
        
        rightCompareView = JXTImageGalleryScrollView(frame: CGRectMake(imagePadding + frame.size.width / 2, imagePadding + 10 + cancelButton!.frame.size.height, frame.size.width / 2, frame.size.height  - cancelButton!.frame.size.height - 10 - (5 * imagePadding)))
        rightCompareView?.direction = .Vertical
        rightCompareView?.imageSize = imageSize
        rightCompareView?.photos = photos
        rightCompareView?.clipsToBounds = true
        self.addSubview(rightCompareView!)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cancelButtonPressed(button: UIButton) {
        self.delegate?.compareViewDidCancel(button)
    }
}
