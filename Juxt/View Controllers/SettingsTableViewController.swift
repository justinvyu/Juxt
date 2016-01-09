//
//  SettingsTableViewController.swift
//  Juxt
//
//  Created by Justin Yu on 12/27/15.
//  Copyright © 2015 Justin Yu. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // Segue Identifiers

    static let PRIVACY_ID = "ShowPrivacy"
    static let EULA_ID = "ShowEULA"
    static let TOS_ID = "ShowTOS"

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let webVC = segue.destinationViewController as? WebViewController {
            var request: NSURLRequest!
            if segue.identifier == SettingsTableViewController.EULA_ID {
                request = NSURLRequest(URL: NSURL(string: "https://medium.com/@justinvyu14/juxt-app-end-user-license-agreement-367edc4529b0")!)
            } else if segue.identifier == SettingsTableViewController.PRIVACY_ID {
                request = NSURLRequest(URL: NSURL(string: "https://www.google.com")!)
            }
            webVC.request = request
        }
    }

    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: Settings Selectors

    @IBAction func logoutAction(sender: AnyObject) {
        ParseHelper.logoutUser() {
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }


}
