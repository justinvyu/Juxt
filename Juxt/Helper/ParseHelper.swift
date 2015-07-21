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
   
    static func retrieveImagesFromJuxt(juxt: Juxt) -> [Photo]? {
        
        let juxtQuery = PFQuery(className: "Photo")
        juxtQuery.whereKey("fromJuxt", equalTo: juxt)
        var photos: [Photo]? = nil
        juxtQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            photos = objects as? [Photo]
        }
        
        return photos
        
    }
    
}
