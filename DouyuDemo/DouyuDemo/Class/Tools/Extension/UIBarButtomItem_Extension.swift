//
//  UIBarButtomItem_Extension.swift
//  DouyuDemo
//
//  Created by GreatSKL on 2017/8/6.
//  Copyright © 2017年 GreatSKL. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName: String, highlightedImageName: String?, size: CGSize?) {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        if let name = highlightedImageName {
            btn.setImage(UIImage(named: name), for: .highlighted)
        }
        if let tmpSize = size {
            btn.frame = CGRect(origin: .zero, size: tmpSize)
        } else {
            btn.sizeToFit()
        }
        
        
        self.init(customView: btn)
    }
    
    class func createItem(imageName: String, highlightedImageName: String, size: CGSize) -> UIBarButtonItem{
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highlightedImageName), for: .highlighted)
        btn.frame = CGRect(origin: .zero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
}
