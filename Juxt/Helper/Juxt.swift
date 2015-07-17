//
//  Juxt.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse

class Juxt: PFObject, PFSubclassing {
   
    var title: String = ""
    var desc: String = ""
    
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
