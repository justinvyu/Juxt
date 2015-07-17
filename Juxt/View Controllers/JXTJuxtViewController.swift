//
//  JXTJuxtViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class JXTJuxtViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        
        
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
