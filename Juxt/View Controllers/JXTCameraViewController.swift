//
//  JXTCameraViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/19/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import AVFoundation
import LLSimpleCamera
import TGCameraViewController
import Parse
import ParseUI

class JXTCameraViewController: UIViewController {

    // MARK: PROPERTIES
    
    var juxt: Juxt? // Juxt holder to tell the addPhotoVC what Juxt the photo is for
    
    var camera: LLSimpleCamera?
    
    var snapButton: UIButton?
    var flashButton: UIButton?
    var switchButton: UIButton?
    var cancelButton: UIButton?
    var translucentGuideView: PFImageView?
    
    var originalVC: UIViewController?
    
//    var cancelButtonHidden: Bool? = false
//    var addPhotoCancelButtonHidden: Bool? = false
    
//    let captureSession = AVCaptureSession()
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    var captureDevice: AVCaptureDevice?
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        
        self.navigationController?.navigationBarHidden = true
        
        let screenRect = UIScreen.mainScreen().bounds
        
        self.camera = LLSimpleCamera()
        self.camera?.attachToViewController(self, withFrame: CGRectMake(0, 0, screenRect.width, screenRect.height))
        self.camera?.tapToFocus = false
        
        self.setupCaptureUI()
        
//        captureSession.sessionPreset = AVCaptureSessionPresetHigh
//        
//        let devices = AVCaptureDevice.devices()
//        
//        for device in devices {
//            if device.hasMediaType(AVMediaTypeVideo) {
//                if device.position == .Back {
//                    captureDevice = device as? AVCaptureDevice
//                    
//                    if captureDevice != nil {
//                        beginSession()
//                    }
//                }
//            }
//        }
        
        self.camera?.start()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.camera?.stop()
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        snapButton?.center = self.view.center
        snapButton?.frame.origin.y = self.view.frame.size.height - 85
        
        flashButton?.center = self.view.center
        flashButton?.frame.origin.y = 5.0
        
        switchButton?.frame.origin.x = self.view.frame.width - 53
        switchButton?.frame.origin.y = 5.0
    }
    
    // MARK: HELPER FUNCTIONS
    
//    func beginSession() {
//        var err: NSError? = nil
//        
//        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
//        
//        if err != nil {
//            println("error: \(err?.localizedDescription)")
//        }
//        
//        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.view.layer.addSublayer(previewLayer)
//        previewLayer?.frame = self.view.layer.frame
//        
//        captureSession.startRunning()
//    }
    
    func setupCaptureUI() {

        if let photos = self.juxt?.photos {
            if photos.count != 0 {
                
                let photo = photos[photos.count - 1]
                translucentGuideView = PFImageView(frame: self.view.frame)
                translucentGuideView?.file = photo.imageFile
                self.view.addSubview(translucentGuideView!)
                translucentGuideView?.alpha = 0.25
                
                translucentGuideView?.contentMode = .ScaleAspectFill
                translucentGuideView?.loadInBackground()
            }
        }
        
        snapButton = UIButton.buttonWithType(.Custom) as? UIButton
        snapButton?.frame = CGRectMake(0, 0, 70, 70)
        snapButton?.clipsToBounds = true
        snapButton?.layer.cornerRadius = snapButton!.frame.width / 2.0
        snapButton?.layer.borderColor = UIColor.whiteColor().CGColor
        snapButton?.layer.borderWidth = 2.0
        snapButton?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        snapButton?.layer.rasterizationScale = UIScreen.mainScreen().scale
        snapButton?.layer.shouldRasterize = true
        snapButton?.addTarget(self, action: Selector("snapButtonPressed:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(snapButton!)
        
        flashButton = UIButton.buttonWithType(.Custom) as? UIButton
        flashButton?.frame = CGRectMake(0, 0, 16.0 + 20.0, 24.0 + 20.0)
        flashButton?.tintColor = UIColor.whiteColor()
        flashButton?.setImage(UIImage(named: "camera-flash"), forState: .Normal)
        flashButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        flashButton?.layer.cornerRadius = 5.0
        flashButton?.addTarget(self, action: Selector("flashButtonPressed:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(flashButton!)
        
        switchButton = UIButton.buttonWithType(.Custom) as? UIButton
        switchButton?.frame = CGRectMake(0, 0, 29.0 + 20.0, 22.0 + 20.0)
        switchButton?.tintColor = UIColor.whiteColor()
        switchButton?.setImage(UIImage(named: "camera-switch"), forState: .Normal)
        switchButton?.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        switchButton?.addTarget(self, action: Selector("switchButtonPressed:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(switchButton!)
        
        cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
        cancelButton?.frame = CGRectMake(5, 4, 44, 44)
        cancelButton?.tintColor = JXTConstants.defaultBlueColor()
        cancelButton?.setImage(UIImage(named: "cancel-blue"), forState: .Normal)
        cancelButton?.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        cancelButton?.addTarget(self, action: Selector("cancelButtonPressed:"), forControlEvents: .TouchUpInside)
        self.view.addSubview(cancelButton!)
        
        if camera?.flash.value == CameraFlashOn.value {
            flashButton?.selected = true
            flashButton?.backgroundColor = JXTConstants.defaultBlueColor()
        } else {
            flashButton?.selected = false
            flashButton?.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    func snapButtonPressed(button: UIButton) {
        
        self.camera?.capture({ (camera, image, metadata, error) -> Void in
            if error == nil {
                
                // Stop the camera and open a new vc or else there will be a crash
                camera.stop()
                
                // Present VC   
                let addPhotoController = JXTAddPhotoViewController()
                addPhotoController.delegate = self
                addPhotoController.juxt = self.juxt
//                addPhotoController.addPhotoCancelButtonHidden = self.addPhotoCancelButtonHidden
                let navigationController = UINavigationController(rootViewController: addPhotoController)
                addPhotoController.image = image
                addPhotoController.originalVC = self.originalVC
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }, exactSeenImage: true)
        
    }
    
    func flashButtonPressed(button: UIButton) {
        
        if camera!.flash.value == CameraFlashOff.value {
            let done = self.camera?.updateFlashMode(CameraFlashOn)
            if done == true {
                flashButton?.selected = true
                flashButton?.backgroundColor = JXTConstants.defaultBlueColor()
            } else {
                flashButton?.enabled = false
            }
        } else {
            let done = self.camera?.updateFlashMode(CameraFlashOff)
            if done == true {
                flashButton?.selected = false
                flashButton?.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    func switchButtonPressed(button: UIButton) {
        camera?.togglePosition()
        let done = self.camera?.updateFlashMode(CameraFlashOff)
        flashButton?.selected = false
        flashButton?.backgroundColor = UIColor.clearColor()
        if done == true {
            flashButton?.enabled = true
        } else {
            flashButton?.enabled = false
        }
        
    }
    
    func cancelButtonPressed(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension JXTCameraViewController: JXTAddPhotoViewControllerDelegate {
    
    func retakePicture() {        
        self.camera?.start()
    }
    
}
