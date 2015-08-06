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
    
    static let Facebook = "Facebook"
    static let Twitter = "Twitter"
    
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
}
