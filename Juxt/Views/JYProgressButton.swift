//
//  JYProgressButton.swift
//  Juxt
//
//  Created by Justin Yu on 7/30/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class JYProgressButton: UIButton {

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    init(frame: CGRect, animating: Bool) {
        
        let indicatorSize = CGSizeMake(frame.size.height - 10, frame.size.height - 10)
        
        activityIndicator.frame = CGRectMake(frame.size.width - indicatorSize.width - 5, 5, indicatorSize.width, indicatorSize.height)
        
        if animating {
            activityIndicator.startAnimating()
        }
        
        
        super.init(frame: frame)
        
        activityIndicator.color = UIColor.whiteColor()
        self.backgroundColor = JXTConstants.defaultBlueColor()
        self.addSubview(activityIndicator)
        self.layer.cornerRadius = 5.0
        
    }
    
    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
}
