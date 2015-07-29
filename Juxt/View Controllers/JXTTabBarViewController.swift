//
//  JXTTabBarViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/27/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class JXTTabBarViewController: UIViewController {

    @IBOutlet weak var tabBar: UITabBar!
    var tab1ViewController: JXTJuxtViewController?
    var tab2ViewController: JXTCompareViewController?
    var currentViewController: UIViewController?
    
    var juxt: Juxt? {
        didSet {
            tab1ViewController?.juxt = juxt
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = false
        let tabBarItems = tabBar.items as? [UITabBarItem]
        self.tabBar.delegate = self
        if let selectedItem = tabBarItems?[0] {
            tabBar.selectedItem = selectedItem
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if tab1ViewController == nil {
            println("instantiating vc")
            self.tab1ViewController =
                self.storyboard?.instantiateViewControllerWithIdentifier("JuxtVC") as? JXTJuxtViewController
            println(self.juxt)
            self.tab1ViewController?.juxt = self.juxt
        }
        self.view.insertSubview(self.tab1ViewController!.view, belowSubview: tabBar)
        
//        if tab1ViewController == nil {
//            println("instantiating vc")
//            self.tab1ViewController =
//                self.storyboard?.instantiateViewControllerWithIdentifier("JuxtVC") as? JXTJuxtViewController
//            self.tab1ViewController?.juxt = self.juxt
//            println(self.tab1ViewController?.juxt)
//        }
//        self.view.insertSubview(self.tab1ViewController!.view, belowSubview: tabBar)
//        if currentViewController != nil {
//            currentViewController!.view.removeFromSuperview()
//        }
//        currentViewController = tab1ViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension JXTTabBarViewController: UITabBarDelegate {
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
        switch item.tag {
            case 1:
                if tab1ViewController == nil {
                    println("instantiating vc")
                    self.tab1ViewController =
                        self.storyboard?.instantiateViewControllerWithIdentifier("JuxtVC") as? JXTJuxtViewController
                    self.tab1ViewController?.juxt = self.juxt
                    //println(self.tab1ViewController?.juxt)
                } else {
                    if tab1ViewController == self.currentViewController {
                        return
                    }
                }
                self.view.insertSubview(self.tab1ViewController!.view, belowSubview: tabBar)
                if currentViewController != nil {
                    currentViewController!.view.removeFromSuperview()
                }
                currentViewController = tab1ViewController
            case 2:
                if tab2ViewController == nil {
                    self.tab2ViewController =
                        self.storyboard?.instantiateViewControllerWithIdentifier("CompareVC") as? JXTCompareViewController
                    self.tab2ViewController?.photos = self.tab1ViewController?.photos
                } else {
                    if tab2ViewController == self.currentViewController {
                        return
                    }
                }
                self.view.insertSubview(self.tab2ViewController!.view, belowSubview: tabBar)
                if currentViewController != nil {
                    currentViewController!.view.removeFromSuperview()
                }
                currentViewController = tab2ViewController
            default:
                println("Tag out of bounds")
        }
    }
}
