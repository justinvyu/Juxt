//
//  JXTHomeTableViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/15/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import Parse
import ParseUI
import ConvenienceKit

import FBSDKCoreKit
import FBSDKShareKit
import ParseFacebookUtils

class JXTHomeTableViewController: PFQueryTableViewController {

    // MARK: Properties
    
    var juxts: [Juxt]?
    var imageLoadQueue: dispatch_queue_t?
    
    // MARK: Init
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = ParseHelper.ProjectClassName
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
//        self.objectsPerPage = 8
        self.loadingViewEnabled = false
        
    }
    
    // MARK: PFQueryTableViewController
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: ParseHelper.ProjectClassName)
        query.orderByDescending("createdAt")
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if (self.objects?.count == 0) {
            query.cachePolicy = .CacheThenNetwork
        } else {
            query.cachePolicy = .CacheThenNetwork
        }

        return query
        
    }
    
    // MARK: Other Funcs
    
    func presentProfileViewController(button: UIBarButtonItem) {
        
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! UIViewController
        self.presentViewController(profileViewController, animated: true, completion: nil)
        
    }
    
    func presentAddJuxtViewController(button: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("AddJuxt", sender: nil)
        
    }
    
    @IBAction func performJuxtSegue(sender: UITapGestureRecognizer) {
        
//        println(sender.view as? JXTImageGalleryScrollView)
//        if let galleryView = sender.view as? JXTImageGalleryScrollView {
//            println(galleryView.indexPath?.row)
//            self.tableView.selectRowAtIndexPath(galleryView.indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
//        }

    }
    
    // MARK: UIActionSheets
    
    func showActionSheetForPost(post: Juxt) {
        if (post.user == PFUser.currentUser()) {
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
                    self.loadObjects()
                    self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
        }
        
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: VC Methods
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseHelper.getUserInformationFromFB()
        
        self.followScrollView(self.tableView)
        self.setUseSuperview(false)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        var profileButton = UIBarButtonItem(image: UIImage(named: "profile"), landscapeImagePhone: nil, style: .Plain, target: self, action: "presentProfileViewController:")
        
        profileButton.tintColor = UIColor(white: 0.97, alpha: 1.0)
        profileButton.imageInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        
        var addJuxtButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "presentAddJuxtViewController:")
        addJuxtButton.tintColor = UIColor(white: 0.97, alpha: 1.0)
        
        self.navigationItem.rightBarButtonItems = [addJuxtButton, profileButton]
        
        tableView.contentInset = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        imageLoadQueue = dispatch_queue_create("imageLoad", DISPATCH_QUEUE_SERIAL)
        
        tableView.estimatedRowHeight = 184
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.tableView.reloadData()
//        self.loadObjects()
//        self.tableView.insertSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> JXTJuxtTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("JuxtCell") as! JXTJuxtTableViewCell!
        if cell == nil {
            cell = JXTJuxtTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "JuxtCell")
        }
        
        cell.profilePictureImageView.layer.cornerRadius = 5.0
        
        if let juxt = object as? Juxt, cell = cell {
            cell.juxt = juxt
            cell.juxt?.photosForJuxt() { (photos) -> Void in
                cell.galleryScrollView.photos = photos as [Photo]?
            }
            cell.homeViewController = self
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
//        if let tableView = scrollView as? UITableView {
//            self.navigationController?.scrollNavigationBar.resetToDefaultPositionWithAnimation(true)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                
        if segue.identifier == "ShowJuxt" {
            if let juxtCell = sender as? JXTJuxtTableViewCell {
                if let juxtViewController = segue.destinationViewController as? JXTJuxtViewController {
                    juxtViewController.juxt = juxtCell.juxt
                    juxtViewController.presentingTableViewCell = sender as? JXTJuxtTableViewCell
                }
//                if let navController = segue.destinationViewController as? UINavigationController {
//                    if let tabBarViewController = navController.viewControllers?[0] as? JXTTabBarViewController {
//                        tabBarViewController.juxt = juxtCell.juxt
//                    }
//                }
            } else if let tap = sender as? UITapGestureRecognizer {
                println(tap)
                if let galleryView = tap.view as? JXTImageGalleryScrollView {
                    if let juxtViewController = segue.destinationViewController as? JXTJuxtViewController {
                        juxtViewController.juxt = galleryView.juxt
                    }
                }
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
        
        searchBar.resignFirstResponder()
    }
    
}