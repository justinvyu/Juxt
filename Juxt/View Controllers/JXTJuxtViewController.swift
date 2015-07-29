//
//  JXTJuxtViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import APParallaxHeader
import Parse
import ParseUI

//protocol JXTJuxtViewControllerDelegate {
//    
//    func didLoadPhotos(photos: [Photo])
//    
//}

class JXTJuxtViewController: UIViewController {
   
    // MARK: Properties
    
//    var delegate: JXTJuxtViewControllerDelegate?
    var juxt: Juxt?
    var photos: [Photo]?
    var imageLoadQueue: dispatch_queue_t?
    
    var fullScreenImageView: UIImageView?
    var fullScreenCancelButton: UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    var compareView: JXTCompareView?
    
    @IBOutlet weak var compareButton: UIButton!
    var photoTakingHelper: PhotoTakingHelper?
    
    // MARK: Helper Funcs
    
    func addPhotoButtonPressed(sender: UIBarButtonItem) {
        
        if let juxt = juxt {
            
            photoTakingHelper = PhotoTakingHelper(viewController: self, juxt: juxt, cameraOnly: true, cancelButtonHidden: false)
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
        
        var borderedFirstImage = firstImage.borderImage(UIColor.whiteColor(), borderWidth: 30)
        var borderedSecondImage = secondImage.borderImage(UIColor.whiteColor(), borderWidth: 30)
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
        
    }
    
    func fullScreenCancelButtonPressed(sender: UIButton) {
        
        JXTConstants.fadeOutWithDuration(fullScreenImageView!, duration: 0.3)
        JXTConstants.fadeOutWithDuration(fullScreenCancelButton!, duration: 0.3)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)

    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 315
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationItem.title = juxt?.title
        println(self.navigationItem.title)
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhotoButtonPressed:")
        addButton.tintColor = UIColor.whiteColor()
        
//        let compareButton = UIBarButtonItem(image: UIImage(named: "compare"), landscapeImagePhone: nil, style: .Plain, target: self, action: "compareButtonTapped:")

        let compareButton = UIBarButtonItem(image: UIImage(named: "share"), landscapeImagePhone: nil, style: .Plain, target: self, action: "compareButtonTapped:")
        
        self.navigationItem.rightBarButtonItems = [addButton, compareButton]
        
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        
        if let juxt = juxt {
            dispatch_async(self.imageLoadQueue!) {
                self.photos = ParseHelper.retrieveImagesFromJuxt(juxt, mostRecent: true)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        println("view will appear")
        //self.tabBarController?.tabBar.hidden = false

        if let juxt = juxt {
            dispatch_async(self.imageLoadQueue!) {
                self.photos = ParseHelper.retrieveImagesFromJuxt(juxt, mostRecent: true)
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if let compareVC = self.storyboard?.instantiateViewControllerWithIdentifier("CompareVC") as? JXTCompareViewController {
                        println(compareVC)
                        compareVC.photos = self.photos
                    }
                    
                    
//                    if let photos = self.photos {
//                        self.delegate?.didLoadPhotos(photos)
//                    }
                    self.tableView.reloadData()
                }
                
            }
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        tableView.reloadData()
        
        self.tabBarController?.tabBar.hidden = false
        self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        self.tabBarController?.tabBar.hidden = false
    }
}

extension JXTJuxtViewController: JXTCompareViewDelegate {
    
    func compareViewDidCancel(button: UIButton) {
        JXTConstants.fadeOutWithDuration(self.compareView!, duration: 0.3)
        self.tableView.userInteractionEnabled = true
    }
    
    func compareButtonWasPressedWithImages(compareView: JXTCompareView, firstImage: UIImage, secondImage: UIImage) {
        println(self.combineImage(image: firstImage, withImage: secondImage))
        
        let testView = UIImageView(frame: CGRectMake(20, 0, self.view.frame.size.width - 40, self.view.frame.size.height))
        testView.image = self.combineImage(image: firstImage, withImage: secondImage)
        //testView.image = testView.image?.borderImage(UIColor.whiteColor(), borderWidth: 5.0)
        testView.contentMode = .ScaleAspectFit
        compareView.addSubview(testView)
        JXTConstants.fadeInWidthDuration(compareView, duration: 0.3)
    }
    
}

extension JXTJuxtViewController: UITableViewDelegate {
    
}

extension JXTJuxtViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return UITableViewAutomaticDimension
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.photos?.count != 0 {
            tableView.backgroundView?.removeFromSuperview()
            tableView.backgroundView = nil
            return 1
        } else {
//            var label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
//            label.text = "Looks like there's nothing here!\nClick the '+' button to get started or swipe to refresh."
//            label.numberOfLines = 0
//            label.textAlignment = .Center
//            label.font = UIFont.systemFontOfSize(18.0)
//            label.sizeToFit()
            
            //tableView.backgroundView = label
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
        cell.delegate = self
        
        return cell
    }
}

extension JXTJuxtViewController: JXTPhotoTableViewCellDelegate {
    
    func imageViewWasPressedWithImage(image: UIImage) {
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
        
        self.fullScreenImageView = UIImageView()
        self.fullScreenImageView?.frame = self.view.frame
        self.fullScreenImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        self.fullScreenImageView?.clipsToBounds = true

        self.fullScreenImageView?.image = image
        self.navigationController?.view.addSubview(self.fullScreenImageView!)
        
        fullScreenCancelButton = UIButton.buttonWithType(.Custom) as? UIButton
        fullScreenCancelButton?.frame = CGRectMake(5, 4, 44, 44)
        fullScreenCancelButton?.tintColor = JXTConstants.defaultBlueColor()
        fullScreenCancelButton?.setImage(UIImage(named: "cancel-blue"), forState: .Normal)
        fullScreenCancelButton?.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        fullScreenCancelButton?.addTarget(self, action: Selector("fullScreenCancelButtonPressed:"), forControlEvents: .TouchUpInside)
        self.navigationController?.view.addSubview(fullScreenCancelButton!)
        
        JXTConstants.fadeInWidthDuration(self.fullScreenImageView!, duration: 0.3)
        
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
//    -(UIImage *)imageBorderedWithColor:(UIColor *)color borderWidth:(CGFloat)width
//    {
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
//    [self drawAtPoint:CGPointZero];
//    [color setStroke];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.size.width, self.size.height)];
//    path.lineWidth = width;
//    [path stroke];
//    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return result;
//    }
    
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
