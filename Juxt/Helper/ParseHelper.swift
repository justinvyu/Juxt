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
    
    // Flagged Content
    
    static let FlaggedContentClassName = "FlaggedContent"
    static let FlaggedContentFromUser = "fromUser"
    static let FlaggedContentToJuxt = "toJuxt"
    
    // FB
    
    static func loginWithFacebook(completion: PFUserResultBlock) {
        let permissionsArray = ["email", "public_profile"]
        
        PFFacebookUtils.logInWithPermissions(permissionsArray, block: completion)
    }
    
    static func userName(user: PFUser) -> String? {
//        return PFUser.currentUser()?[UserName] as? String
        return user[UserName] as? String
    }
    
    static func userProfilePicture(user: PFUser) -> PFFile? {
//        return PFUser.currentUser()?[UserProfilePicture] as? PFFile
        
        return user[UserProfilePicture] as? PFFile
    }
    
    static func getUserInformationFromFB() {
        let nameRequest = FBSDKGraphRequest(graphPath: "/me?fields=name,picture", parameters: nil, HTTPMethod: "GET")
        nameRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                // Process error
                println("Error: \(error)")
            } else {
                PFUser.currentUser()?.setValue(result.valueForKey(self.UserName) as? String, forKey: self.UserName)
                
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
    
    // MARK: Flagging
    
//    static func flagsForPost(post: Juxt, completion: PFArrayResultBlock) {
//        
//        let flagQuery = PFQuery(className: FlaggedContentClassName)
//        flagQuery.whereKey(FlaggedContentToJuxt, equalTo: post)
//        
//        flagQuery.includeKey(FlaggedContentFromUser)
//        flagQuery.findObjectsInBackgroundWithBlock(completion)
//        
//    }
//    
//    static func flagPost(user: PFUser, post: Juxt) {
//        
//        let flag = PFObject(className: FlaggedContentClassName)
//        flag[FlaggedContentFromUser] = user
//        flag[FlaggedContentToJuxt] = post
//        flag.saveInBackground()
//        
//    }
//    
//    static func unflagPost(user: PFUser, post: Juxt) {
//        
//        let flagQuery = PFQuery(className: FlaggedContentClassName)
//        flagQuery.whereKey(FlaggedContentFromUser, equalTo: user)
//        flagQuery.whereKey(FlaggedContentToJuxt, equalTo: post)
//        
//        flagQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//            if error != nil {
//                println("\(error)")
//            } else {
//                if let flags = results as? [PFObject] {
//                    for flag in flags {
//                        flag.deleteInBackground()
//                    }
//                    
//                }
//            }
//        }
//        
//    }
    
    static func flagPost(user: PFUser, post: Juxt) {
        let flagObject = PFObject(className: FlaggedContentClassName)
        flagObject.setObject(user, forKey: FlaggedContentFromUser)
        flagObject.setObject(post, forKey: FlaggedContentToJuxt)
        
        let ACL = PFACL(user: PFUser.currentUser()!)
        ACL.setPublicReadAccess(true)
        flagObject.ACL = ACL
        
        let postACL = PFACL(user: post.user!)
        postACL.setPublicReadAccess(false)
        post.ACL = postACL
        post.saveInBackground()
        
        //TODO: add error handling
        flagObject.saveInBackgroundWithBlock(nil)
    }
    
    static func juxtsFromUser(user: PFUser, completion: PFArrayResultBlock) {
        
        let query = PFQuery(className: ProjectClassName)
        query.whereKey(ProjectUser, equalTo: user)
        query.findObjectsInBackgroundWithBlock(completion)
        
    }
    
    static func retrieveImagesFromJuxt(juxt: Juxt, mostRecent: Bool) -> [Photo]? {
        
        let juxtQuery = PFQuery(className: PhotoClassName)
        juxtQuery.cachePolicy = PFCachePolicy.NetworkElseCache
        juxtQuery.whereKey(PhotoFromProject, equalTo: juxt)
        
        if mostRecent {
            juxtQuery.orderByDescending(PhotoCreatedAt)
        }
        
        var photos: [Photo]? = juxtQuery.findObjects() as? [Photo]
        
        return photos
        
    }
    
}

extension PFObject: Equatable {
    
}

public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}

public func !=(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}
