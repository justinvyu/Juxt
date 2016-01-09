//
//  WebViewController.swift
//  Juxt
//
//  Created by Justin Yu on 12/27/15.
//  Copyright © 2015 Justin Yu. All rights reserved.
//

import UIKit
import MBProgressHUD

class WebViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var webView: UIWebView!
    var request: NSURLRequest?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self

        MBProgressHUD.showHUDAddedTo(webView, animated: true)

        if let request = request {
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WebViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        MBProgressHUD.hideHUDForView(webView, animated: true)
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
    }
}
