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
import MPCoachMarks
import SCLAlertView

protocol JXTJuxtViewControllerDelegate {
    
    func deletedJuxt()
    func flaggedJuxt()
    
}

class JXTJuxtViewController: UIViewController {
   
    // MARK: Properties
    
    var juxt: Juxt?
    var photos: [Photo]?
    var imageLoadQueue: dispatch_queue_t?
    
    var delegate: JXTJuxtViewControllerDelegate?
    
    var fullScreenImageView: UIImageView?
    var fullScreenCancelButton: UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    var compareView: JXTCompareView?
    var GIFView: JXTGIFView?
    
    @IBOutlet weak var compareButton: UIButton!
    var photoTakingHelper: PhotoTakingHelper?
    var backgroundActivityView: UIActivityIndicatorView?
    var content: FBSDKSharePhotoContent?
    
    var presentingTableViewCell: JXTJuxtTableViewCell?
    
    var shareButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?
    
    // MARK: TableViewCell (Delegate)
    
    func showActionSheetForPhoto(photo: Photo) {
        
        let alertController = UIAlertController(title: nil, message: "Do you want to delete this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let retakeAction = UIAlertAction(title: "Retake", style: .Default) { (action) in
            
            print("retake")
            
        }
        alertController.addAction(retakeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func showActionSheetForPost(post: Juxt) {
        if (post.user?.objectId == PFUser.currentUser()?.objectId) {
            showDeleteActionSheetForPost(post)
        } else {
            showFlagActionSheetForPost(post)
        }
    }
    
    func showDeleteActionSheetForPost(post: Juxt) {
        let alertController = UIAlertController(title: nil, message: "Do you want to delete this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            
            if let photos = post.photos {
                for photo in photos {
                    photo.deleteInBackgroundWithBlock(nil)
                }
            }
            
            post.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    
                    MixpanelHelper.trackDeletePost()
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    self.delegate?.deletedJuxt()
//                    self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                }
            })
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showFlagActionSheetForPost(post: Juxt) {
        let alertController = UIAlertController(title: nil, message: "Do you want to flag this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Flag", style: .Destructive) { (action) in
            post.flagPost(PFUser.currentUser()!)
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.delegate?.flaggedJuxt()
        }
        
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showFullScreenImage(image: UIImage) {
        
        self.fullScreenImageView?.removeFromSuperview()
        self.fullScreenCancelButton?.removeFromSuperview()
        
        self.fullScreenImageView = UIImageView()
        self.fullScreenImageView?.frame = self.view.frame
        self.fullScreenImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.fullScreenImageView?.clipsToBounds = true
        
        self.fullScreenImageView?.image = image
        self.navigationController?.view.addSubview(self.fullScreenImageView!)
        
        fullScreenCancelButton = UIButton(type: .Custom) as? UIButton
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
            self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        }
    }
    
    // MARK: Helper Funcs
    
    func addPhotoButtonPressed(sender: UIBarButtonItem) {
        
        if let juxt = juxt {
            
            photoTakingHelper = PhotoTakingHelper(viewController: self, juxt: juxt, cameraOnly: true, returnHome: false/*, cancelButtonHidden: false, addPhotoCancelButton: true*/)
        }
        
//        let cameraViewController = JXTCameraViewController()
//        cameraViewController.juxt = self.juxt
//        self.presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    
    func shareButtonTapped(sender: UIBarButtonItem) {
        
        let shareView = SCLAlertView()
        shareView.addButton("Create a before and after") {
            self.showSideBySideScreen()
        }
        shareView.addButton("Create an animated GIF") {
            self.showGIFScreen()
        }
        shareView.showNotice("Share", subTitle: "Compare with a before and after image or link everything together with an animated GIF!", closeButtonTitle: "Cancel", colorStyle: 0x3498db)
        
    }
    
    func showSideBySideScreen() {
        compareView = JXTCompareView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), photos: self.photos!)
        compareView?.delegate = self
        self.tableView.userInteractionEnabled = false
        self.navigationController?.view.addSubview(compareView!)
        JXTConstants.fadeInWidthDuration(compareView!, duration: 0.6)
        self.tableView.userInteractionEnabled = false
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        }
    }
    
    func showGIFScreen() {
        if let juxt = self.juxt {
            GIFView = JXTGIFView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), juxt: juxt)
            GIFView?.delegate = self
            self.navigationController?.view.addSubview(GIFView!)
            JXTConstants.fadeInWidthDuration(GIFView!, duration: 0.6)
            if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
                self.navigationController?.interactivePopGestureRecognizer!.enabled = false
            }
            self.tableView.userInteractionEnabled = false
        }
    }
    
    func fullScreenCancelButtonPressed(sender: UIButton) {
        
        JXTConstants.fadeOutWithDuration(fullScreenImageView!, duration: 0.3)
        
//        self.navigationController?.view.subviews.map { JXTConstants.fadeInWidthDuration($0 as! UIView, duration: 0.25) }
        JXTConstants.fadeOutWithDuration(fullScreenCancelButton!, duration: 0.3)
        self.tableView.userInteractionEnabled = true
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        }
        self.shareButton?.enabled = true
        self.addButton?.enabled = true
        self.navigationItem.hidesBackButton = false

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)

    }
    
//    @IBAction func GIFButtonPressed(sender: UIButton) {
//        
//        self.juxt?.downloadPhotos() { images in
//            if let gifHelper = self.gifHelper, juxt = self.juxt, images = images {
//                gifHelper.createGIFWithImages(images) { gifData in
//                    
//                    gifHelper.postGIFToImgur(gifData, title: juxt.title, description: juxt.desc)
//                    
//                }
//            }
//        }
//        
//    }
    
    func showShareDialog() {

        FBSDKShareDialog.showFromViewController(self, withContent: self.content, delegate: self)
        
    }
    
    // MARK: Setup Coachmarks
    
    func setupCoachmarks() {
        
        if !CoachmarksHelper.coachmarkHasBeenViewed(CoachmarksHelper.keys.CompareUser) || !CoachmarksHelper.coachmarkHasBeenViewed(CoachmarksHelper.keys.AddPhoto) {
            let compareCoachmarkRect = CGRectMake(self.view.frame.size.width - 108, 15, 55, 55)
            let compareCoachmark = CoachmarksHelper.generateCoachmark(rect: compareCoachmarkRect, caption: "Compare your photos in a side by side image or an animated gif", shape: MaskShape.SHAPE_CIRCLE, position: LabelPosition.LABEL_POSITION_BOTTOM, alignment: LabelAligment.LABEL_ALIGNMENT_CENTER, showArrow: true)
            
            let addPhotoCoachmarkRect = CGRectMake(self.view.frame.size.width - 52, 15, 55, 55)
            let addPhotoCoachmark = CoachmarksHelper.generateCoachmark(rect: addPhotoCoachmarkRect, caption: "Add a photo to your project's timeline", shape: MaskShape.SHAPE_CIRCLE, position: LabelPosition.LABEL_POSITION_BOTTOM, alignment: LabelAligment.LABEL_ALIGNMENT_CENTER, showArrow: true)
            
            var coachmarks: [CoachmarksHelper.mark] = []
            
            coachmarks = CoachmarksHelper.addMarkToCoachmarks(coachmarks, newMark: compareCoachmark)
            coachmarks = CoachmarksHelper.addMarkToCoachmarks(coachmarks, newMark: addPhotoCoachmark)
            let coachmarkView = CoachmarksHelper.generateCoachmarksViewWithMarks(marks: coachmarks, withFrame: self.view.frame)
            self.navigationController?.view.addSubview(coachmarkView)
            coachmarkView.enableContinueLabel = false
            coachmarkView.enableSkipButton = false
            coachmarkView.start()
            
            CoachmarksHelper.setCoachmarkHasBeenViewedToTrue(CoachmarksHelper.keys.CompareUser)
            CoachmarksHelper.setCoachmarkHasBeenViewedToTrue(CoachmarksHelper.keys.AddPhoto)
        }
        
    }
    
    func setupCoachmarks_notUser() {
        
        if !CoachmarksHelper.coachmarkHasBeenViewed(CoachmarksHelper.keys.Header) {
            let headerCoachmarkRect = CGRectMake(0, self.navigationController!.navigationBar.frame.size.height + 20, self.view.frame.size.width, 68)
            let headerCoachmark = CoachmarksHelper.generateCoachmark(rect: headerCoachmarkRect, caption: "You're checking out someone else's project!", shape: MaskShape.SHAPE_SQUARE, position: LabelPosition.LABEL_POSITION_BOTTOM, alignment: LabelAligment.LABEL_ALIGNMENT_CENTER, showArrow: true)
            
            let compareCoachmarkRect = CGRectMake(self.view.frame.size.width - 52, 15, 55, 55)
            let compareCoachmark = CoachmarksHelper.generateCoachmark(rect: compareCoachmarkRect, caption: "Compare their photos in a side by side image or an animated gif", shape: MaskShape.SHAPE_CIRCLE, position: LabelPosition.LABEL_POSITION_BOTTOM, alignment: LabelAligment.LABEL_ALIGNMENT_CENTER, showArrow: true)
            
            var coachmarks: [CoachmarksHelper.mark] = []
            
            coachmarks = CoachmarksHelper.addMarkToCoachmarks(coachmarks, newMark: headerCoachmark)
            coachmarks = CoachmarksHelper.addMarkToCoachmarks(coachmarks, newMark: compareCoachmark)
            let coachmarkView = CoachmarksHelper.generateCoachmarksViewWithMarks(marks: coachmarks, withFrame: self.view.frame)
            self.navigationController?.view.addSubview(coachmarkView)
            coachmarkView.enableContinueLabel = false
            coachmarkView.enableSkipButton = false
            coachmarkView.start()
            
            CoachmarksHelper.setCoachmarkHasBeenViewedToTrue(CoachmarksHelper.keys.Header)
        }
        
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
        self.navigationItem.title = "juxt"
        self.navigationItem.titleView?.tintColor = UIColor(white: 0.97, alpha: 1.0)
        
//        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), landscapeImagePhone: nil, style: .Plain, target: self, action: "shareButtonTapped:")
//        shareButton.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        if PFUser.currentUser()?.objectId == juxt?.user?.objectId {
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhotoButtonPressed:")
            addButton.tintColor = UIColor.whiteColor()
            
            self.navigationItem.rightBarButtonItem = addButton
//            self.navigationItem.rightBarButtonItems = [addButton, shareButton]
            self.addButton = addButton
        } else {
//            self.navigationItem.rightBarButtonItem = shareButton
        }
        
//        self.shareButton = shareButton
        
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

//        if PFUser.currentUser() == juxt?.user {
//            self.setupCoachmarks()
//        } else {
//            self.setupCoachmarks_notUser()
//        }
//        
//        self.gifHelper = GIFHelper()
//        self.gifHelper?.viewController = self
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

extension JXTJuxtViewController: JXTPopupViewDelegate {
    
    func popupViewDidCancel(button: UIButton) {
        if let compareView = self.compareView {
            JXTConstants.fadeOutWithDuration(compareView, duration: 0.25)
        }
        
        if let gifView = self.GIFView {
            JXTConstants.fadeOutWithDuration(gifView, duration: 0.25)
        }
        
//        self.navigationController?.view.subviews.map { JXTConstants.fadeInWidthDuration($0 as! UIView, duration: 0.25) }
        self.navigationItem.hidesBackButton = false
        self.tableView.userInteractionEnabled = true
        if self.navigationController?.respondsToSelector("interactivePopGestureRecognizer") == true {
            self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        }
    }
    
    func compareButtonWasPressedWithImages(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage) {
        //println(self.combineImage(image: firstImage, withImage: secondImage))
        
        let mergeImage = ImageHelper.combineImage(image: firstImage, withImage: secondImage)
        
        let fbPhoto = FBSDKSharePhoto(image: ImageHelper.scaleImage(mergeImage, width: 640), userGenerated: true)
        let content = FBSDKSharePhotoContent()
        content.photos = [fbPhoto]
        
        self.content = content
        
        self.showShareDialog()
    }
    
    func saveToCameraRoll(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage) {
        let mergeImage = ImageHelper.combineImage(image: firstImage, withImage: secondImage)
        
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
        
        if self.photos?.count != 0 && self.juxt != nil {
            tableView.backgroundView?.removeFromSuperview()
            tableView.backgroundView = nil
            return 2
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Int(photos?.count ?? 0)
        
        switch section {
        case 0:
            return 1
        case 1:
            return Int(photos?.count ?? 0)
        default:
            print("Out of bounds??")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! JXTHeaderTableViewCell
            
            cell.juxt = self.juxt
            cell.profilePicture.layer.cornerRadius = 5.0
            cell.profilePicture.contentMode = .ScaleAspectFill
            cell.juxtViewController = self

            if juxt!.doesUserLikePost(PFUser.currentUser()!) {
                cell.likeButton.selected = true
            }

            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! JXTPhotoTableViewCell
            
            if let photos = photos {
                let photo = photos[photos.count - 1 - indexPath.row]
                cell.photo = photo
            }
            
            cell.juxtViewController = self
            cell.layoutIfNeeded()

            return cell
        default:
            return UITableViewCell()
            
        }

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
                
        
        
    }
    
}
