    //
//  AppDelegate.swift
//  Juxt
//
//  Created by Justin Yu on 7/14/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import FBSDKCoreKit
import Parse
import Bolts
import ParseFacebookUtils

//import Realm
//import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // REALM stuff
//        setSchemaVersion(1, Realm.defaultPath, { migration, oldSchemaVersion in
//            // We haven’t migrated anything yet, so oldSchemaVersion == 0
//            if oldSchemaVersion < 1 {
//                migration.enumerate(Juxt.className()) { oldObject, newObject in
//                    println("enumerating")
//                    println(oldObject!["title"])
//                    //newObject!["images"] = [] as [JXTImage]
//                }
//            }
//        })
//        
//        let realm = Realm()
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Normal)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(18)]
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // Initialize Parse.
        Parse.setApplicationId("HIXqAn876G6WymYy8YQvMtu1uBxGC6zhgMc2EmYn",
            clientKey: "s1k0Zvy6lpiwCAexjHwd3JeZxEh0U3ApTguMFVXF")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Setup Parse Facebook Utils
        PFFacebookUtils.initializeFacebook()
        
//        Fabric.with([Twitter()])
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
        PFFacebookUtils.session()?.handleDidBecomeActive()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

