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
import ParseFacebookUtils

class JXTProfileViewController: UIViewController {

    // Properties
    
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var juxts: [Juxt]?
    
    // VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = ParseHelper.userName(PFUser.currentUser()!)
        
        let file = ParseHelper.userProfilePicture(PFUser.currentUser()!)
        self.profilePicture.file = file
        self.profilePicture.loadInBackground()
        
        self.profilePicture.layer.cornerRadius = 5.0
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 340
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.titleView?.tintColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor(white: 0.97, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.loadData()
    }
    
    // Helper Funcs
    
    func loadData() {
        ParseHelper.juxtsFromUser(PFUser.currentUser()!) { (objects, error) -> Void in
            if error != nil {
                println("\(error)")
            } else {
                println(self.juxts)
                self.juxts = objects as! [Juxt]?
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func settingsButtonTapped(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: self.nameLabel.text, message: nil, preferredStyle: .ActionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            ParseHelper.logoutUser() {
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        let tutorialAction = UIAlertAction(title: "Reset Tutorial", style: .Default) { (action) in
            CoachmarksHelper.resetCoachmarksHaveBeenViewed()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addAction(tutorialAction)
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
        println(self.juxts?.count)
        return Int(self.juxts?.count ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("JuxtCell") as! JXTJuxtTableViewCell
        
        cell.juxt = self.juxts?[indexPath.row]
        cell.juxt?.fetchLikes()
        cell.profilePictureImageView.layer.cornerRadius = 5.0
        
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
    
}
