//
//  UIButton+utilities.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(
        title:String,
        _ titleColor: UIColor = UIColor.black,
        _ titleSize: CGFloat = 15.0) {
        
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(SecondaryColor, for: .disabled)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: titleSize)
    }
}
