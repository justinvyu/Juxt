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

class JXTJuxtViewController: UIViewController {
   
    // MARK: Properties
    
    var juxt: Juxt?
    var photos: [Photo]?
    var imageLoadQueue: dispatch_queue_t?
    
    @IBOutlet weak var tableView: UITableView!
    var compareView: JXTCompareView?
    
    @IBOutlet weak var compareButton: UIButton!
    var photoTakingHelper: PhotoTakingHelper?
    
    // MARK: Helper Funcs
    
    @IBAction func addPhotoButtonPressed(sender: UIBarButtonItem) {
        
        if let juxt = juxt {
            
            photoTakingHelper = PhotoTakingHelper(viewController: self, juxt: juxt)
        }
        
//        let cameraViewController = JXTCameraViewController()
//        cameraViewController.juxt = self.juxt
//        self.presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func compareButtonTapped(sender: UIButton) {
        
        compareView = JXTCompareView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), photos: self.photos!)
        compareView?.delegate = self
        self.tableView.userInteractionEnabled = false
        self.navigationController?.view.addSubview(compareView!)
        JXTConstants.fadeInWidthDuration(compareView!, duration: 0.3)
        
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
        self.navigationController?.navigationItem.title = juxt?.title
        
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let juxt = juxt {
            dispatch_async(self.imageLoadQueue!) {
                self.photos = ParseHelper.retrieveImagesFromJuxt(juxt, mostRecent: true)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        tableView.reloadData()
    }
}

extension JXTJuxtViewController: JXTCompareViewDelegate {
    
    func compareViewDidCancel(button: UIButton) {
        JXTConstants.fadeOutWithDuration(self.compareView!, duration: 0.3)
        self.tableView.userInteractionEnabled = true
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
            var label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            label.text = "Looks like there's nothing here!\nClick the '+' button to get started or swipe to refresh."
            label.numberOfLines = 0
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(18.0)
            label.sizeToFit()
            
            tableView.backgroundView = label
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
        
        return cell
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
