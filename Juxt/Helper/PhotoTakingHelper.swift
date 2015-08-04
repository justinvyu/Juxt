//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Justin Yu on 6/26/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void // returning a block

class PhotoTakingHelper : NSObject {
    
    /** View controller on which AlertViewController and UIImagePickerController are presented */
    weak var viewController: UIViewController!
    
    var juxt: Juxt?
//    var cancelButtonHidden: Bool?
    
//    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, juxt: Juxt, cameraOnly: Bool/*, cancelButtonHidden: Bool, addPhotoCancelButton: Bool, callback: PhotoTakingHelperCallback*/) {
        self.viewController = viewController
//        self.callback = callback
//        self.cancelButtonHidden = cancelButtonHidden
        self.juxt = juxt
        
        super.init()
        
        if cameraOnly {
            presentCamera()
        } else {
            showPhotoSourceSelection()
        }
        // showImagePickerController(.Camera) // switch after download to phone
    }
    
    func presentCamera() {
        
        let cameraViewController = JXTCameraViewController()
        cameraViewController.juxt = self.juxt
//        cameraViewController.cancelButtonHidden = self.cancelButtonHidden
        viewController.presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
        
    }
    
    func showPhotoSourceSelection() {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default, handler: { (action) in // action is the param
                self.presentCamera()
            })
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default, handler: { (action) in
            self.showImagePickerController(.PhotoLibrary)
        })
        
        alertController.addAction(photoLibraryAction)
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let addPhotoVC = JXTAddPhotoViewController()
        let navController = UINavigationController(rootViewController: addPhotoVC)
        addPhotoVC.image = image
        addPhotoVC.juxt = self.juxt
        picker.presentViewController(navController, animated: true, completion: nil)
        
        //callback(image)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}