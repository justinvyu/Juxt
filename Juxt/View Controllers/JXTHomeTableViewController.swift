//
//  JXTHomeTableViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/15/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import GTScrollNavigationBar
import Parse
import ParseUI
import ConvenienceKit

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
    
    // MARK: Init
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Juxt"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
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
    
    // MARK: VC Methods
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        timelineComponent = TimelineComponent(target: self)
        
        self.navigationController?.scrollNavigationBar.scrollView = self.tableView
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        
        let searchBar = UISearchBar(frame: CGRectMake(-5, 0, 320, 44))
        searchBar.autoresizingMask = .FlexibleWidth
        let searchView = UIView(frame: CGRectMake(0, 0, 310, 44))
        searchBar.delegate = self
        searchView.addSubview(searchBar)
        self.searchBar = searchBar
        self.navigationItem.titleView = searchBar
        
        tableView.contentInset = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
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
        
        if let juxt = object as? Juxt {
            cell?.juxt = juxt
            let photos = ParseHelper.retrieveImagesFromJuxt(juxt)
            println(photos)
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



