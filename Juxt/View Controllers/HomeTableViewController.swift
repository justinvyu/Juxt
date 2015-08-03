//
//  HomeTableViewController.swift
//  Juxt
//
//  Created by Justin Yu on 8/3/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

import GTScrollNavigationBar
import AMScrollingNavbar
import Parse
import ParseUI
import ConvenienceKit

import FBSDKCoreKit
import FBSDKShareKit
import ParseFacebookUtils

class HomeTableViewController: UITableViewController {

    // MARK: Properties
    
    var juxts: [Juxt]? // all juxts, query for it at view did load
    var imageLoadQueue: dispatch_queue_t?
    
    // MARK: Other Funcs
    
    func presentProfileViewController(button: UIBarButtonItem) {
        
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! UIViewController
        self.presentViewController(profileViewController, animated: true, completion: nil)
        
    }
    
    func presentAddJuxtViewController(button: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddJuxt", sender: nil)
        
    }
    
    @IBAction func performJuxtSegue(sender: UITapGestureRecognizer) {
        
        self.performSegueWithIdentifier("ShowJuxt", sender: sender)
    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        timelineComponent = TimelineComponent(target: self)
        //        self.navigationController?.scrollNavigationBar.scrollView = self.tableView
        //        self.navigationController?.scrollNavigationBar.scrollView.delegate = self
        
        self.followScrollView(self.tableView)
        self.setUseSuperview(false)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        var profileButton = UIBarButtonItem(image: UIImage(named: "profile"), landscapeImagePhone: nil, style: .Plain, target: self, action: "presentProfileViewController:")
        
        profileButton.tintColor = UIColor.whiteColor()
        profileButton.imageInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        
        var addJuxtButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "presentAddJuxtViewController:")
        addJuxtButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItems = [addJuxtButton, profileButton]
        
        tableView.contentInset = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        
        tableView.estimatedRowHeight = 184
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.showNavBarAnimated(true)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        if tableView.respondsToSelector(Selector("setSeparatorInset:")) {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Int(self.juxts?.count ?? 0)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("JuxtCell") as! JXTJuxtTableViewCell!
        if cell == nil {
            cell = JXTJuxtTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "JuxtCell")
        }
        
        cell.profilePictureImageView.layer.cornerRadius = 5.0
        
        let row = indexPath.row
    
        if let juxt = self.juxts?[row], cell = cell {
            
            cell.juxt = juxt
            
            // Photo Gallery
            
            let juxtQuery = PFQuery(className: "Photo")
            juxtQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
            juxtQuery.whereKey("fromJuxt", equalTo: juxt)
            juxtQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if error == nil {
                    
                    if cell.galleryScrollView.photos?.count != objects?.count {
                        cell.galleryScrollView.photos = objects as? [Photo]
                        cell.juxt?.photos = objects as? [Photo]
                        
                    }
                    
                }
            })
            
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
