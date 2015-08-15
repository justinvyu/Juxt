//
//  JXTGIFView.swift
//  Juxt
//
//  Created by Justin Yu on 8/14/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import FLAnimatedImage

class JXTGIFView: UIView {

    // MARK: Properties
    
    // Buttons & Labels
    
    var cancelButton: UIButton?
    var compareLabel: UILabel?
    
    var saveButton: UIButton?
    var bottomBar: UIView?
    var facebookButton: UIButton?
    
    var whiteBackgroundView: UIView?
    var gifPreview: FLAnimatedImageView?
    
    var delaySlider: UISlider?
    
    // Delegate
    
    var delegate: JXTPopupViewDelegate?
    
    // GIF
    
    var GIF: NSData?
    var gifHelper: GIFHelper?
    var juxt: Juxt?
    
    // MARK: Init
    
    init(frame: CGRect, juxt: Juxt) {
        
        self.gifHelper = GIFHelper()
        self.juxt = juxt
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = frame
        
        self.addSubview(blurView)
        
        compareLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        compareLabel?.center = self.center
        compareLabel?.frame.origin.y = 20
        compareLabel?.text = "share an animated GIF"
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
        
        self.generateGIF()
        
        whiteBackgroundView = UIView(frame: CGRectMake(35, 0, frame.size.width - 70, frame.size.width - 70))
        whiteBackgroundView?.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        self.addSubview(whiteBackgroundView!)
        whiteBackgroundView?.center = self.center
        
        gifPreview = FLAnimatedImageView(frame: CGRectMake(40, 0, frame.size.width - 80, frame.size.width - 80))
        self.addSubview(gifPreview!)
        gifPreview?.center = self.center
        gifPreview?.contentMode = .ScaleAspectFill
        gifPreview?.clipsToBounds = true
        
        bottomBar = UIView(frame: CGRectMake(0, frame.size.height - 60, frame.size.width, 60))
        bottomBar?.backgroundColor = JXTConstants.defaultBlueColor().colorWithAlphaComponent(0.9)
        self.addSubview(bottomBar!)
        
//        saveButton = UIButton(frame: CGRectMake(bottomBar!.frame.size.width / 2 - 44 - 30, 5, 44, 44))
//        saveButton?.setImage(UIImage(named: "download"), forState: .Normal)
//        saveButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
//        bottomBar?.addSubview(saveButton!)
//        saveButton?.addTarget(self, action: "saveToCameraRoll:", forControlEvents: .TouchUpInside)
        
        facebookButton = UIButton(frame: CGRectMake(bottomBar!.frame.size.width / 2 - 22, 5, 44, 44))
//        facebookButton?.center = bottomBar!.center
        facebookButton?.setImage(UIImage(named: "facebook"), forState: .Normal)
        facebookButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        bottomBar?.addSubview(facebookButton!)
        //        facebookButton?.center.x = bottomBar!.center.x
        facebookButton?.addTarget(self, action: "shareFacebook:", forControlEvents: .TouchUpInside)
        
//        delaySlider = UISlider(frame: <#CGRect#>)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Selectors
    
    func cancelButtonPressed(button: UIButton) {
        self.delegate?.popupViewDidCancel(button)
    }
    
    func generateGIF() {
        
        self.juxt?.downloadPhotos() { images in
            if let gifHelper = self.gifHelper, juxt = self.juxt, images = images {
                gifHelper.createGIFWithImages(images) { gifData in
                    
                    // Show GIF
                    
                    let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
                    self.gifPreview?.animatedImage = animatedImage
                    
//                    gifHelper.postGIFToImgur(gifData, title: juxt.title, description: juxt.desc)
                    
                }
            }
        }
        
    }
    
    func shareFacebook(button: UIButton) {
        
        if let juxt = self.juxt, data = self.gifPreview?.animatedImage.data {
            gifHelper?.postGIFToImgur(data, title: juxt.title, description: juxt.desc)

        }
        
    }
}