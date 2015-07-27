//
//  TestViewController.swift
//  Juxt
//
//  Created by Justin Yu on 7/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var imagePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension TestViewController: UIPickerViewDelegate {
    
}

extension TestViewController: UIPickerViewDataSource {
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var imageView = UIImageView(image: UIImage(named: "splash"))
        
        view.addSubview(imageView)
        
        return view
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        let imageView = UIImageView(image: UIImage(named: "splash"))
        
        return imageView.frame.size.height + 20
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 10
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
}