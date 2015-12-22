//
//  JXTProfileViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/28/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class JXTProfileViewController: UIViewController {

    // Properties

    @IBOutlet weak var tableView: UITableView!
    var spinner: UIActivityIndicatorView!

    var token: dispatch_once_t = 0
    var hasInitialized = false

    var juxts: [Juxt]?
    
    // VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let file = ParseHelper.userProfilePicture(PFUser.currentUser()!)
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.hidesWhenStopped = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.titleView?.tintColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

        if !hasInitialized {
            spinner.startAnimating()
            self.loadData()
        }
        hasInitialized = true
    }
    
    // Helper Funcs
    
    func loadData() {

        ParseHelper.juxtsFromUser(PFUser.currentUser()!) { (objects, error) -> Void in
            if error != nil {
                print("\(error)")
            } else {
                self.juxts = objects as! [Juxt]?
                if self.juxts?.count == 0 {
                    let message = UILabel(frame: CGRectMake(0, 0, 100, 80))
                    message.text = "You currently have no posts. \nReturn to the home screen to\ncreate one."
                    message.numberOfLines = 0
                    message.center = self.tableView.center
                    message.textAlignment = .Center
                    message.textColor = UIColor.lightGrayColor()
                    message.font = UIFont.systemFontOfSize(20)
                    self.tableView.backgroundView = message
                }
                self.tableView.reloadData()
                self.spinner.stopAnimating()
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func settingsButtonTapped(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            ParseHelper.logoutUser() {
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
//        let tutorialAction = UIAlertAction(title: "Reset Tutorial", style: .Default) { (action) in
//            CoachmarksHelper.resetCoachmarksHaveBeenViewed()
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
//        alertController.addAction(tutorialAction)
        alertController.addAction(logoutAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetForPost(post: Juxt) {
        if (post.user == PFUser.currentUser()) {
            showDeleteActionSheetForPost(post)
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
                    self.loadData()
                    //                    self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
                }
            })
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowJuxt" {
            if let juxtCell = sender as? JXTJuxtTableViewCell {
                if let juxtViewController = segue.destinationViewController as? JXTJuxtViewController {
                    juxtViewController.juxt = juxtCell.juxt
                    juxtViewController.delegate = self
                    juxtViewController.presentingTableViewCell = sender as? JXTJuxtTableViewCell
                }
            }
        }
    }

}

extension JXTProfileViewController: UITableViewDelegate {
    
}

extension JXTProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.juxts?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("JuxtCell") as! JXTJuxtTableViewCell
        
        cell.juxt = self.juxts?[indexPath.row]
        cell.juxt?.fetchLikes()
        cell.profilePictureImageView.layer.cornerRadius = 5.0
        cell.profilePictureImageView.contentMode = .ScaleAspectFill
        
        cell.juxt?.photosForJuxt() { (photos) -> Void in
            //                cell.galleryScrollView.photos = photos as [Photo]?
            cell.sideBySideView.photos = photos as [Photo]?
        }
        
        return cell
    }
    
}

extension JXTProfileViewController: JXTJuxtViewControllerDelegate {
    
    func deletedJuxt() {
        self.loadData()
    }
    
    func flaggedJuxt() {
        print("This is not possible...")
    }
    
}
