//
//  MixpanelHelper.swift
//  Juxt
//
//  Created by Justin Yu on 8/5/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Mixpanel

class MixpanelHelper: NSObject {
    
    // Constants
    
    // Network
    static let SignUp = "Sign Up"
    static let LogIn = "Log In"
    static let Network = "Network"
    static let LogOut = "Log Out"
    
    static let Facebook = "Facebook"
    static let Twitter = "Twitter"
    
    // In App functions
    static let CreatePost = "Create Post"
    static let AddPhoto = "Add Photo"
    static let FlagPost = "Flag"
    static let CompareAction = "Compare Action"
    static let Action = "Action"
    
    static let Delete = "Delete"
    static let DeleteAction = "Action"
    static let DeletePost = "Post"
    static let DeletePhoto = "Photo"
    
    static let CancelUpload = "Cancel"
    static let AtStep = "At Step"
    static let CreateProject = "Create Project"
    static let Camera = "Camera"
    static let DescribeImage = "Describe Image"
    
    enum CompareActionType: String {
        case SaveToCameraRoll = "Save to Camera Roll"
        case ShareToFacebook = "Share to Facebook"
    }
    
    // Mixpanel
    
    static var mixpanel = Mixpanel.sharedInstance()
    
    static func trackFacebookSignup() {
        self.mixpanel.track(SignUp, properties: [Network: Facebook])
    }
    
    static func trackTwitterSignup() {
        self.mixpanel.track(SignUp, properties: [Network: Twitter])
    }
    
    static func trackFacebookLogin() {
        self.mixpanel.track(LogIn, properties: [Network: Facebook])
    }
    
    static func trackTwitterLogin() {
        self.mixpanel.track(LogIn, properties: [Network: Twitter])
    }
    
    static func trackFacebookLogout() {
        self.mixpanel.track(LogOut, properties: [Network: Facebook])
    }
    
    static func trackTwitterLogout() {
        self.mixpanel.track(LogOut, properties: [Network: Twitter])
    }
    
    static func trackFlag() {
        self.mixpanel.track(FlagPost)
    }
    
    static func trackCreatePost() {
        self.mixpanel.track(CreatePost)
    }
    
    static func trackAddPhoto() {
        self.mixpanel.track(AddPhoto)
    }
    
    static func trackCompareAction(action: CompareActionType) {
        switch action {
        case .SaveToCameraRoll:
            self.mixpanel.track(CompareAction, properties: [Action: CompareActionType.SaveToCameraRoll.rawValue])
        case .ShareToFacebook:
            self.mixpanel.track(CompareAction, properties: [Action: CompareActionType.ShareToFacebook.rawValue])
        default:
            println("Nothing to track")
        }
    }
    
    static func trackCancelAtCreateProject() {
        self.mixpanel.track(CancelUpload, properties: [AtStep: CreateProject])
    }
    
    static func trackCancelAtCamera() {
        self.mixpanel.track(CancelUpload, properties: [AtStep: Camera])
    }
    
    static func trackCancelAtDescribeImage() {
        self.mixpanel.track(CancelUpload, properties: [AtStep: DescribeImage])
    }
    
    static func trackDeletePost() {
        self.mixpanel.track(Delete, properties: [DeleteAction: DeletePost])
    }
}
