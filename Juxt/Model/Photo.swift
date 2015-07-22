//
//  Photo.swift
//  Juxt
//
//  Created by Justin Yu on 7/17/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Parse

class Photo: PFObject, PFSubclassing {
   
    // MARK: Properties
    
    var image: UIImage?
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var fromJuxt: Juxt?
    @NSManaged var imageFile: PFFile?
    
    // MARK: Parse Functions
    
    func uploadPhoto(completion: PFBooleanResultBlock) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imageFile = PFFile(data: imageData)
        
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            
        }
        
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            
        }
        self.imageFile = imageFile
        saveInBackgroundWithBlock(completion)
        
    }
    
    func downloadImage() {
        if image == nil {
            imageFile?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale: 1.0)
                    self.image = image
                }
            })
        }
    }
    
    // MARK: PFSubclassing
    
    static func parseClassName() -> String {
        return "Photo"
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
