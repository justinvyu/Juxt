//
//  JXTJuxtViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import APParallaxHeader

class JXTJuxtViewController: UIViewController {
   
    // MARK: Properties
    
    var juxt: Juxt?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var parallaxView: UIView!
    
    // MARK: Helper Funcs
    
    @IBAction func addPhotoButtonPressed(sender: UIBarButtonItem) {
        
        let cameraViewController = JXTCameraViewController()
        cameraViewController.juxt = self.juxt
        self.presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    // MARK: VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        tableView.delegate = self
        tableView.dataSource = self

        if let juxt = juxt {
            titleLabel.text = juxt.title
        }
        
    }
}

extension JXTJuxtViewController: UITableViewDelegate {
    
}

extension JXTJuxtViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! UITableViewCell
        
        return cell
        
    }
}
