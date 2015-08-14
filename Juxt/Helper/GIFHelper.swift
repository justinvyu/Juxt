//
//  GIFHelper.swift
//  Juxt
//
//  Created by Justin Yu on 8/13/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

import FBSDKCoreKit
import FBSDKShareKit

class GIFHelper: NSObject {
       
    weak var viewController: UIViewController?
    
    func createGIFWithImages(images: [UIImage], completion: NSData -> Void) {
        
        dispatch_async(dispatch_queue_create("createGIF", DISPATCH_QUEUE_SERIAL)) {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingPathComponent("animated.gif")
            let destination = CGImageDestinationCreateWithURL(NSURL(fileURLWithPath: path!) as! CFURLRef, kUTTypeGIF, images.count, nil)
            let frameProperties = [
                kCGImagePropertyGIFDictionary as String : [
                    kCGImagePropertyGIFDelayTime as String : NSNumber(float: 0.15)
                ]
            ]
            let gifProperties = [
                kCGImagePropertyGIFDictionary as String : [
                    kCGImagePropertyGIFLoopCount as String : NSNumber(int: 0)
                ]
            ]
            
            for image in images {
                CGImageDestinationAddImage(destination, image.CGImage, frameProperties)
            }
            CGImageDestinationSetProperties(destination, gifProperties)
            CGImageDestinationFinalize(destination)
            println("animated GIF file created at \(path)")
            
            let gif = NSData(contentsOfFile: path!)
            completion(gif!)
        }
    }
    
    func postGIFToImgur(gif: NSData, title: String?, description: String?) {
            
            let CLIENT_KEY = "9e0492acb161044"
            
            dispatch_async(dispatch_queue_create("uploadIMGUR", DISPATCH_QUEUE_SERIAL)) {
                MLIMGURUploader.uploadPhoto(gif, title: title, description: description, imgurClientID: CLIENT_KEY, completionBlock: { (result) -> Void in
                    //println(result)
                    
                    let url = FBSDKShareLinkContent()
                    url.contentURL = NSURL(string: result)
                                        
                    FBSDKShareDialog.showFromViewController(self.viewController, withContent: url, delegate: nil)
                    
                    }, failureBlock: { (response, error, status) -> Void in
                        println("\(error)")
                })
            }
        }
    
}
