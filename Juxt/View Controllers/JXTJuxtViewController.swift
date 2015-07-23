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
        
        let testView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.size.width, UIScreen.mainScreen().applicationFrame.size.height))
        testView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(testView)
        
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
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        
        if let juxt = juxt {
            dispatch_async(self.imageLoadQueue!) {
                self.photos = ParseHelper.retrieveImagesFromJuxt(juxt)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let juxt = juxt {
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "compare" {
            let destination = segue.destinationViewController as! UIViewController
            destination.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            self.modalPresentationStyle = .CurrentContext
            destination.modalPresentationStyle = .CurrentContext
        }
        
    }
}

extension JXTJuxtViewController: UITableViewDelegate {
    
}

extension JXTJuxtViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(photos?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! JXTPhotoTableViewCell
        
        let photo = photos?[indexPath.row]
        
        cell.photoView.file = photo?.imageFile
        cell.photoView.layer.cornerRadius = 5.0
        cell.photoView.contentMode = .ScaleAspectFill
        cell.photoView.clipsToBounds = true
        cell.photoView.image = UIImage(named: "default-placeholder")
        cell.titleLabel.text = photo?.title
        cell.photoView.loadInBackground()
        
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
