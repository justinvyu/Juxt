//
//  Juxt.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse

typealias JuxtCallback = [Photo]? -> Void // returning a block

class Juxt: PFObject, PFSubclassing {
    
    var photos: [Photo]?
    
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var date: NSDate?
    @NSManaged var user: PFUser?
    
    // MARK: Parse Functions
    
    func photosForJuxt(completion: JuxtCallback) {
        if photos != nil {
            completion(photos)
        } else {
            let juxtQuery = PFQuery(className: "Photo")
            juxtQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
            juxtQuery.whereKey("fromJuxt", equalTo: self)
            juxtQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                self.photos = objects as? [Photo]
                completion(objects as? [Photo])
            })
        }
    }
    
    func uploadJuxt(completion: PFBooleanResultBlock) {
        
        if let currentUser = PFUser.currentUser() {
         
            let acl = PFACL()
            acl.setPublicReadAccess(true)
            acl.setWriteAccess(true, forUser: currentUser)
            self.user = currentUser
        }
        saveInBackgroundWithBlock(completion)
        
    }
    
    // MARK: PFSubclassing
    
    static func parseClassName() -> String {
        return "Juxt"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0
        
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
        
    }
}
