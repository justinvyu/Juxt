//
//  JXTJuxtViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKCoreKit
import FBSDKShareKit

//protocol JXTJuxtViewControllerDelegate {
//    
//    func didLoadPhotos(photos: [Photo])
//    
//}

class JXTJuxtViewController: UIViewController {
   
    // MARK: Properties
    
    var juxt: Juxt?
    var photos: [Photo]?
    var imageLoadQueue: dispatch_queue_t?
    
    var fullScreenImageView: UIImageView?
    var fullScreenCancelButton: UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    var compareView: JXTCompareView?
    
    @IBOutlet weak var compareButton: UIButton!
    var photoTakingHelper: PhotoTakingHelper?
    var backgroundActivityView: UIActivityIndicatorView?
    var content: FBSDKSharePhotoContent?
    
    var presentingTableViewCell: JXTJuxtTableViewCell?
    
    var shareButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?
    
    // MARK: UIActionSheets
    
    func showActionSheetForPhoto(photo: Photo) {
        showDeleteActionSheetForPhoto(photo)
    }
    
    func showDeleteActionSheetForPhoto(photo: Photo) {
        let alertController = UIAlertController(title: nil, message: "Do you want to delete this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            
            
            
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Helper Funcs
    
    func addPhotoButtonPressed(sender: UIBarButtonItem) {
        
        if let juxt = juxt {
            
            photoTakingHelper = PhotoTakingHelper(viewController: self, juxt: juxt, cameraOnly: true/*, cancelButtonHidden: false, addPhotoCancelButton: true*/)
        }
        
//        let cameraViewController = JXTCameraViewController()
//        cameraViewController.juxt = self.juxt
//        self.presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    // Juxtapose images
    func combineImage(image firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        var image: UIImage
        
        var newImageSize = CGSizeMake(firstImage.size.width + secondImage.size.width, max(firstImage.size.height, secondImage.size.height))
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.mainScreen().scale)
        
        var borderedFirstImage = firstImage.borderImage(UIColor(white: 0.97, alpha: 1.0), borderWidth: 30)
        var borderedSecondImage = secondImage.borderImage(UIColor(white: 0.97, alpha: 1.0), borderWidth: 30)
        borderedFirstImage.drawAtPoint(CGPointMake(0, 0))
        borderedSecondImage.drawAtPoint(CGPointMake(firstImage.size.width - 15, 0))
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func compareButtonTapped(sender: UIBarButtonItem) {
        
        compareView = JXTCompareView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), photos: self.photos!)
        compareView?.delegate = self
        self.tableView.userInteractionEnabled = false
        self.navigationController?.view.addSubview(compareView!)
        JXTConstants.fadeInWidthDuration(compareView!, duration: 0.3)
        self.tableView.userInteractionEnabled = false
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer.enabled = false
        }
        
    }
    
    func fullScreenCancelButtonPressed(sender: UIButton) {
        
        JXTConstants.fadeOutWithDuration(fullScreenImageView!, duration: 0.3)
        JXTConstants.fadeOutWithDuration(fullScreenCancelButton!, duration: 0.3)
        self.tableView.userInteractionEnabled = true
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer.enabled = true
        }
        self.shareButton?.enabled = true
        self.addButton?.enabled = true
        self.navigationItem.hidesBackButton = false

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)

    }
    
    func showShareDialog() {

        FBSDKShareDialog.showFromViewController(self, withContent: self.content, delegate: self)
        
    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundActivityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        backgroundActivityView?.startAnimating()
        self.tableView.backgroundView = backgroundActivityView
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 640
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationItem.title = juxt?.title
        self.navigationItem.titleView?.tintColor = UIColor(white: 0.97, alpha: 1.0)
        
        let compareButton = UIBarButtonItem(image: UIImage(named: "share"), landscapeImagePhone: nil, style: .Plain, target: self, action: "compareButtonTapped:")
        if PFUser.currentUser()?.objectId == juxt?.user?.objectId {
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhotoButtonPressed:")
            addButton.tintColor = UIColor.whiteColor()
            
            self.navigationItem.rightBarButtonItems = [addButton, compareButton]
            self.addButton = addButton
        } else {
            self.navigationItem.rightBarButtonItem = compareButton
        }
        
        self.shareButton = compareButton
        
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        
        if let juxt = juxt {
//            dispatch_async(self.imageLoadQueue!) {
//                self.photos = ParseHelper.retrieveImagesFromJuxt(juxt, mostRecent: true)
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.tableView.reloadData()
//                    self.backgroundActivityView?.stopAnimating()
//                }
//            }
            self.photos = juxt.photos
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        self.juxt?.reloadPhotos() { (photos) in
            self.photos = photos as [Photo]?
            self.presentingTableViewCell?.juxt?.photos = self.photos
            self.tableView.reloadData()
        }
        
        self.tabBarController?.tabBar.hidden = false
        self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        self.tabBarController?.tabBar.hidden = false
    }
}

extension JXTJuxtViewController: FBSDKSharingDelegate {
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        self.compareView?.shareButton?.stopAnimating()
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        self.compareView?.shareButton?.stopAnimating()
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        self.compareView?.shareButton?.stopAnimating()
    }
    
}

extension JXTJuxtViewController: JXTCompareViewDelegate {
    
    func compareViewDidCancel(button: UIButton) {
        JXTConstants.fadeOutWithDuration(self.compareView!, duration: 0.3)
        self.navigationItem.hidesBackButton = false
        self.tableView.userInteractionEnabled = true
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer.enabled = true
        }
    }
    
    func compareButtonWasPressedWithImages(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage) {
        //println(self.combineImage(image: firstImage, withImage: secondImage))
        
        let mergeImage = self.combineImage(image: firstImage, withImage: secondImage)
        
        let fbPhoto = FBSDKSharePhoto(image: JXTConstants.scaleImage(mergeImage, width: 640), userGenerated: true)
        let content = FBSDKSharePhotoContent()
        content.photos = [fbPhoto]
        
        self.content = content
        
        self.showShareDialog()
        
    }
    
    func saveToCameraRoll(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage) {
        let mergeImage = self.combineImage(image: firstImage, withImage: secondImage)
        
        UIImageWriteToSavedPhotosAlbum(mergeImage, nil, nil, nil);
    }
    
    func shareButtonWasPressed(button: UIButton) {
    }
    
}

extension JXTJuxtViewController: UITableViewDataSource {
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//        
//        return UITableViewAutomaticDimension
//    }
//    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.photos?.count != 0 {
            tableView.backgroundView?.removeFromSuperview()
            tableView.backgroundView = nil
            return 1
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(photos?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! JXTPhotoTableViewCell
        
        let photo = photos?[indexPath.row]
        
        cell.photo = photo
//        cell.delegate = self
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}

extension JXTJuxtViewController: JXTPhotoTableViewCellDelegate {
    
    func imageViewWasPressedWithImage(image: UIImage) {
                
        self.fullScreenImageView = UIImageView()
        self.fullScreenImageView?.frame = self.view.frame
        self.fullScreenImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.fullScreenImageView?.clipsToBounds = true

        self.fullScreenImageView?.image = image
        self.navigationController?.view.addSubview(self.fullScreenImageView!)
        
        fullScreenCancelButton = UIButton.buttonWithType(.Custom) as? UIButton
        fullScreenCancelButton?.frame = CGRectMake(10, 20, 44, 44)
        fullScreenCancelButton?.tintColor = JXTConstants.defaultBlueColor()
        fullScreenCancelButton?.setImage(UIImage(named: "cancel"), forState: .Normal)
        fullScreenCancelButton?.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        fullScreenCancelButton?.addTarget(self, action: Selector("fullScreenCancelButtonPressed:"), forControlEvents: .TouchUpInside)
        self.navigationController?.view.addSubview(fullScreenCancelButton!)
        
        JXTConstants.fadeInWidthDuration(self.fullScreenImageView!, duration: 0.3)
        
        self.navigationItem.hidesBackButton = true
        self.addButton?.enabled = false
        self.shareButton?.enabled = false

        self.tableView.userInteractionEnabled = false
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer.enabled = false
        }
        
    }
    
}

extension UIView {
    func convertViewToImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImage {
    
    func borderImage(color: UIColor, borderWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawAtPoint(CGPointZero)
        color.setStroke()
        var path = UIBezierPath(rect: CGRectMake(0, 0, self.size.width, self.size.height))
        path.lineWidth = borderWidth
        path.stroke()
        var result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
