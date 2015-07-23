//
//  ParseHelper.swift
//  Juxt
//
//  Created by Justin Yu on 7/20/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse

class ParseHelper: NSObject {
   
    static func retrieveImagesFromJuxt(juxt: Juxt, mostRecent: Bool) -> [Photo]? {
        
        let juxtQuery = PFQuery(className: "Photo")
        juxtQuery.cachePolicy = PFCachePolicy.NetworkElseCache
        juxtQuery.whereKey("fromJuxt", equalTo: juxt)
        
        if mostRecent {
            juxtQuery.orderByDescending("createdAt")
        }
        
        var photos: [Photo]? = juxtQuery.findObjects() as? [Photo]
        
        println(photos?.count)
        return photos
        
    }
    
}
