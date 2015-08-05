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
   
    // Parse Classes
    
    // User
    
    static let UserClassName = "_User"
    static let UserName = "name"
    static let UserProfilePicture = "profilePicture"
    
    // Project
    
    static let ProjectClassName = "Juxt"
    static let ProjectTitle = "title"
    static let ProjectCreationDate = "date"
    static let ProjectUser = "user"
    
    // Photo
    
    static let PhotoClassName = "Photo"
    static let PhotoTitle = "title"
    static let PhotoFile = "imageFile"
    static let PhotoDate = "date"
    static let PhotoFromProject = "fromJuxt"
    static let PhotoCreatedAt = "createdAt"
    
    
    // FB
    
    static func loginWithFacebook(completion: PFUserResultBlock) {
        let permissionsArray = ["email", "public_profile", "user_friends"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: completion)
    }
    
    static func userName() -> String? {
        return PFUser.currentUser()?[UserName] as? String
    }
    
    static func userProfilePicture() -> PFFile? {
        return PFUser.currentUser()?[UserProfilePicture] as? PFFile
    }
    
    static func getUserInformationFromFB() {
        let nameRequest = FBSDKGraphRequest(graphPath: "/me?fields=name,picture", parameters: nil, HTTPMethod: "GET")
        nameRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                // Process error
                println("Error: \(error)")
            } else {
                PFUser.currentUser()?.setValue(result.valueForKey(UserName) as? String, forKey: UserName)
                
                let picture = result.valueForKey("picture") as? NSDictionary
                let data = picture?.valueForKey("data") as? NSDictionary
                let url = data?.valueForKey("url") as! String
                
                let imageData = NSData(contentsOfURL: NSURL(string: url)!)
                
                let imageFile = PFFile(data: imageData!)
                
                imageFile.saveInBackgroundWithBlock() { (finished, error) -> Void in
                    if error != nil {
                        println("\(error)")
                    }
                    PFUser.currentUser()?.setObject(imageFile, forKey: self.UserProfilePicture)
                    PFUser.currentUser()?.saveEventually()
                }
                
                //PFUser.currentUser()["name"] = result.valueForKey("name") as? NSString
                //                    PFUser. = result.valueForKey("email") as? String
            }
        })
    }
    
    static func logoutUser(completion: LogoutCallback) {
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
        
        let juxtQuery = PFQuery(className: PhotoClassName)
        juxtQuery.cachePolicy = PFCachePolicy.NetworkElseCache
        juxtQuery.whereKey(PhotoFromProject, equalTo: juxt)
        
        if mostRecent {
            juxtQuery.orderByDescending(PhotoCreatedAt)
        }
        
        var photos: [Photo]? = juxtQuery.findObjects() as? [Photo]
        
        println(photos?.count)
        return photos
        
    }
    
}
