//
//  KeyboardHelper.swift
//  Juxt
//
//  Created by Justin Yu on 12/5/15.
//  Copyright © 2015 Justin Yu. All rights reserved.
//

import UIKit

typealias KeyboardHelperCallback = (height: CGFloat) -> Void

class KeyboardHelper: NSObject {

    var keyboardWillShowHandler: KeyboardHelperCallback?
    var keyboardWillHideHandler: KeyboardHelperCallback?

    init(view: UIView) {
        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification, object: view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification, object: view.window)
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo

        if let keyboardSize = (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            keyboardWillShowHandler?(height: keyboardSize.height)
        }
    }

    func keyboardWillHide(notification: NSNotification) {

    }

}

