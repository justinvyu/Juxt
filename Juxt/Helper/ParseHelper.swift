//
//  ParseHelper.swift
//  Juxt
//
//  Created by Justin Yu on 7/20/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtils
import FBSDKCoreKit

typealias LogoutCallback = () -> Void // returning a block

class ParseHelper: NSObject {
   
    var fbsession: FBSession?
    
    // FB
    
    func getUserInformationFromFB() {
        let nameRequest = FBSDKGraphRequest(graphPath: "/me?fields=name,picture", parameters: nil, HTTPMethod: "GET")
        nameRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                // Process error
                println("Error: \(error)")
            } else {
                PFUser.currentUser()?.setValue(result.valueForKey("name") as? String, forKey: "name")
                
                let picture = result.valueForKey("picture") as? NSDictionary
                let data = picture?.valueForKey("data") as? NSDictionary
                let url = data?.valueForKey("url") as! String
                
                let imageData = NSData(contentsOfURL: NSURL(string: url)!)
                
                let imageFile = PFFile(data: imageData!)
                
                imageFile.saveInBackgroundWithBlock() { (finished, error) -> Void in
                    if error != nil {
                        println("\(error)")
                    }
                    PFUser.currentUser()?.setObject(imageFile, forKey: "profilePicture")
                    PFUser.currentUser()?.saveEventually()
                }
                
                //PFUser.currentUser()["name"] = result.valueForKey("name") as? NSString
                //                    PFUser. = result.valueForKey("email") as? String
            }
        })
    }
    
    func logoutUser(completion: LogoutCallback) {
        PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
            if error == nil {
                PFFacebookUtils.session()?.closeAndClearTokenInformation()
                FBSession.activeSession().closeAndClearTokenInformation()
                completion()
            }
        })
    }
    
    // Other
    
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
