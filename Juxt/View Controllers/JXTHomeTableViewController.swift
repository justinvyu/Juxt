//
//  JXTHomeTableViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/15/15.
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

class JXTHomeTableViewController: PFQueryTableViewController {

    // MARK: Properties
    
//    var juxts: Results<Juxt>! {
//        didSet {
//            tableView?.reloadData()
//        }
//    }
    
//    var timelineComponent: TimelineComponent<Juxt, JXTHomeTableViewController>!
//    let defaultRange = 0...4
//    let additionalRangeSize = 5
    
    var searchBar: UISearchBar?
    var imageLoadQueue: dispatch_queue_t?
    
    // MARK: Init
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Juxt"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 8
        self.loadingViewEnabled = false
        
    }
    
    // MARK: PFQueryTableViewController
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Juxt")
        query.orderByDescending("createdAt")
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects?.count == 0) {
            query.cachePolicy = .CacheThenNetwork;
        }

        return query
        
    }
    
    // MARK: Other Funcs 
    
    func dismissKeyboard() {
        
        searchBar?.resignFirstResponder()
        
    }
    
    func presentProfileViewController(button: UIBarButtonItem) {
        
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! UIViewController
        self.presentViewController(profileViewController, animated: true, completion: nil)
        
    }
    
    func presentAddJuxtViewController(button: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddJuxt", sender: nil)
        
    }
    
    // MARK: VC Methods
    
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
        
        self.loadObjects()
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        
        tableView.estimatedRowHeight = 184
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadObjects()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
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

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> JXTJuxtTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("JuxtCell") as! JXTJuxtTableViewCell!
        if cell == nil {
            cell = JXTJuxtTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "JuxtCell")
        }
        
        cell.profilePictureImageView.layer.cornerRadius = 5.0
        
        if let juxt = object as? Juxt, cell = cell {
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        self.navigationController?.scrollNavigationBar.resetToDefaultPositionWithAnimation(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.searchBar?.resignFirstResponder()
        self.navigationController?.scrollNavigationBar.resetToDefaultPositionWithAnimation(true)
        
        if segue.identifier == "ShowJuxt" {
            println("showing juxt")
            if let juxtCell = sender as? JXTJuxtTableViewCell {
                if let juxtViewController = segue.destinationViewController as? JXTJuxtViewController {
                        juxtViewController.juxt = juxtCell.juxt
                }
//                if let navController = segue.destinationViewController as? UINavigationController {
//                    if let tabBarViewController = navController.viewControllers?[0] as? JXTTabBarViewController {
//                        tabBarViewController.juxt = juxtCell.juxt
//                    }
//                }
            }
        }
    }
}


extension JXTHomeTableViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        self.navigationController?.scrollNavigationBar.scrollView = nil
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: Selector("dismissKeyboard"))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        self.navigationController?.scrollNavigationBar.scrollView = self.tableView
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("Search algorithm")
        
        searchBar.resignFirstResponder()
    }
    
}



