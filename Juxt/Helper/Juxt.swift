//
//  Juxt.swift
//  Juxt
//
//  Created by Justin Yu on 7/16/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse
import Bond

typealias JuxtCallback = [Photo]? -> Void // returning a block
typealias ImagesCallback = [UIImage]? -> Void // returning a block

class Juxt: PFObject, PFSubclassing {
    
    var photos: [Photo]?
    var images: [UIImage]?
//    var likes: [PFUser]?

    var likes =  Observable<[PFUser]?>(nil)

//    var usersFlagged: [PFUser]?
    
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var date: NSDate?
    @NSManaged var user: PFUser?
    
    // MARK: Liking
    func fetchLikes() {
        if (likes.value != nil) {
            return
        }
        
//        ParseHelper.likesForPost(self, completionBlock: { (var likes: [AnyObject]?, error: NSError?) -> Void in
//            likes = likes?.filter { like in like[ParseHelper.LikeFromUser] != nil }
//            
//            self.likes.value = likes?.map { like in
//                let like = like as! PFObject
//                let fromUser = like[ParseHelper.LikeFromUser] as! PFUser
//                
//                return fromUser
//            }
//        })

        ParseHelper.likesForPost(self) { (var likes, error) in
            likes = likes?.filter { like in like[ParseHelper.LikeFromUser] != nil }

            self.likes.value = likes?.map { like in
                let fromUser = like[ParseHelper.LikeFromUser] as! PFUser

                return fromUser
            }
        }
    }
    
    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
//            return likes.contains(user)
            for userWhoLikes in likes {
                if userWhoLikes.objectId == user.objectId {
                    return true
                }
            }
            return false
        } else {
            return false
        }
    }
    
    func toggleLikePost(user: PFUser) {
        if (doesUserLikePost(user)) {
            // if image is liked, unlike it now
            // 1
            likes.value = likes.value?.filter { userWhoLikes in
                return userWhoLikes.objectId != user.objectId
            }
            ParseHelper.unlikePost(user, post: self)
        } else {
            // if this image is not liked yet, like it now
            // 2
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
    
    // MARK: Fetching Photos
    
    func photosForJuxt(completion: JuxtCallback) {
        if photos != nil {
            completion(photos)
        } else {
            reloadPhotos(completion)
        }
    }
    
    // MARK: Flagging
    
    func flagPost(user: PFUser) {
        ParseHelper.flagPost(user, post: self)
    }
    
    func reloadPhotos(completion: JuxtCallback) {
        let juxtQuery = PFQuery(className: ParseHelper.PhotoClassName)
        juxtQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
        juxtQuery.whereKey(ParseHelper.PhotoFromProject, equalTo: self)
        juxtQuery.orderByAscending(ParseHelper.PhotoCreatedAt)
        juxtQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            self.photos = objects as? [Photo]
            completion(objects as? [Photo])
        })
    }
    
    func uploadJuxt(completion: PFBooleanResultBlock) {
        
        if let currentUser = PFUser.currentUser() {
         
            let acl = PFACL()
            acl.publicReadAccess = true
            acl.setWriteAccess(true, forUser: currentUser)
            self.ACL = acl
            self.user = currentUser
        }
        saveInBackgroundWithBlock(completion)
        
    }
    
    func downloadPhotos(completion: ImagesCallback) {
        
        if let photos = self.photos {
            
            self.images = []
            for photo in photos {
                let imageData: NSData?
                do {
                    imageData = try photo.imageFile?.getData()
                } catch _ {
                    continue
                }
                self.images?.append(UIImage(data: imageData!)!)
                
            }
            
            completion(self.images)

        }
        
    }
    
    // MARK: PFSubclassing
    
    static func parseClassName() -> String {
        return ParseHelper.ProjectClassName
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
