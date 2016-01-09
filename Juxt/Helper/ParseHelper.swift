//
//  ParseHelper.swift
//  Juxt
//
//  Created by Justin Yu on 7/20/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKCoreKit

typealias LogoutCallback = () -> Void // returning a block

class ParseHelper: NSObject {
   
    // Parse Classes
    
    // User
    
    static let UserClassName = "_User"
    static let UserName = "username"
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
    static let FlaggedContentToPhoto = "toPhoto"
    
    // Like
    
    static let LikeClassName = "Like"
    static let LikeFromUser = "fromUser"
    static let LikeToJuxt = "toJuxt"
    
    // FB

    static func loginWithFacebook(completion: PFUserResultBlock) {
        let permissionsArray = ["email", "public_profile"]
        
//        PFFacebookUtils.logInWithPermissions(permissionsArray, block: completion)
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissionsArray, block: completion)

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
                print("Error: \(error)")
            } else {
                PFUser.currentUser()?.setValue(result.valueForKey(self.UserName) as? String, forKey: self.UserName)
                
                let picture = result.valueForKey("picture") as? NSDictionary
                let data = picture?.valueForKey("data") as? NSDictionary
                let url = data?.valueForKey("url") as! String
                
                let imageData = NSData(contentsOfURL: NSURL(string: url)!)
                
                let imageFile = PFFile(data: imageData!)
                
                imageFile!.saveInBackgroundWithBlock() { (finished, error) -> Void in
                    if error != nil {
                        print("\(error)")
                    }
                    PFUser.currentUser()?.setObject(imageFile!, forKey: self.UserProfilePicture)
                    PFUser.currentUser()?.saveEventually()
                }
                
                //PFUser.currentUser()["name"] = result.valueForKey("name") as? NSString
                //                    PFUser. = result.valueForKey("email") as? String
            }
        })
    }

    // User Static Functions

    static func createUser(username: String, password: String, profilePicture: UIImage, callback: PFBooleanResultBlock) {
        let user = PFUser()
        user.username = username
        user.password = password

        let imageData = UIImageJPEGRepresentation(profilePicture, 0.8)
        let profilePictureFile = PFFile(data: imageData!)
        profilePictureFile!.saveInBackgroundWithBlock() { success, error in
            
            if success {
                user["profilePicture"] = profilePictureFile
                user.signUpInBackgroundWithBlock(callback)
            } else {
                print(error)
            }
        }

    }

    static func logoutUser(completion: LogoutCallback) {
        PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
            if error == nil {
//                PFFacebookUtils.session()?.closeAndClearTokenInformation()
//                FBSession.activeSession().closeAndClearTokenInformation()
                completion()
            }
        })
    }
    
    // MARK: Flagging
    
    static func flagPost(user: PFUser, post: Juxt) {
        let flagObject = PFObject(className: FlaggedContentClassName)
        flagObject.setObject(user, forKey: FlaggedContentFromUser)
        flagObject.setObject(post, forKey: FlaggedContentToJuxt)
        
        let ACL = PFACL(user: PFUser.currentUser()!)
        flagObject.ACL = ACL

        post.ACL = PFACL(user: post.user!)
        post.ACL!.publicWriteAccess = true
        post.ACL!.publicReadAccess = false

        //        post.ACL?.setReadAccess(false, forUser: user)

        post.saveInBackgroundWithBlock() { result in
            flagObject.saveInBackground()
        }
    }
    
    // MARK: Likes
    
    static func likePost(user: PFUser, post: Juxt) {

        let likeObject = PFObject(className: LikeClassName)
        likeObject[LikeFromUser] = user
        likeObject[LikeToJuxt] = post
        
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user: PFUser, post: Juxt) {
        let query = PFQuery(className: LikeClassName)
        query.whereKey(LikeFromUser, equalTo: user)
        query.whereKey(LikeToJuxt, equalTo: post)

        query.findObjectsInBackgroundWithBlock { results, error in
            if let error = error {
                print("\(error)")
            }

            if let results = results {
                for likes in results {
                    likes.deleteInBackgroundWithBlock(nil)
                }
            }
        }

//        query.findObjectsInBackgroundWithBlock {
//            (results: [AnyObject]?, error: NSError?) -> Void in
//            if let error = error {
//                print("\(error)")
//            }
//            
//            if let results = results as? [PFObject] {
//                for likes in results {
//                    likes.deleteInBackgroundWithBlock(nil)
//                }
//            }
//        }
    }
    
    static func likesForPost(post: Juxt, completionBlock: PFQueryArrayResultBlock) {
        let query = PFQuery(className: LikeClassName)
        query.whereKey(LikeToJuxt, equalTo: post)
        query.includeKey(LikeFromUser)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // MARK: Other
    
    static func juxtsFromUser(user: PFUser, completion: PFQueryArrayResultBlock) {
        
        let query = PFQuery(className: ProjectClassName)
        query.whereKey(ProjectUser, equalTo: user)
        query.orderByDescending(PhotoCreatedAt)
        query.findObjectsInBackgroundWithBlock(completion)
        
    }
    
    static func retrieveImagesFromJuxt(juxt: Juxt, mostRecent: Bool, completion: PFQueryArrayResultBlock) {
        
        let juxtQuery = PFQuery(className: PhotoClassName)
        juxtQuery.cachePolicy = PFCachePolicy.NetworkElseCache
        juxtQuery.whereKey(PhotoFromProject, equalTo: juxt)
        
        if mostRecent {
            juxtQuery.orderByDescending(PhotoCreatedAt)
        }
        
        juxtQuery.findObjectsInBackgroundWithBlock(completion)
        
    }
    
}

extension Equatable {

}

public func ==(lhs: PFObject, rhs: PFObject) -> Bool {
    return lhs.objectId == rhs.objectId
}

//public func !=(lhs: PFObject, rhs: PFObject) -> Bool {
//    return lhs.objectId == rhs.objectId
//}
