//
//  UINavgationBar+utilities.swift
//  opShotRevise
//
//  Created by PSL on 9/18/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func settingDefaultStyle() {
        
        self.navigationBar.shadowImage = UIImage()
        let color = UIColor.black
        var frame = self.navigationBar.frame
        frame.size.height = 64
        let image = UIImage.imageWith(frame: frame, color: color)
        self.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        self.navigationBar.tintColor = UIColor.groupTableViewBackground
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.groupTableViewBackground]
        self.navigationBar.isTranslucent = true
    }
    
    func settingTransparentBar() {
        
        self.navigationBar.shadowImage = UIImage()
        //let color = UIColor.white
        var frame = self.navigationBar.frame
        frame.size.height = 64
        //let image = UIImage.imageWith(frame: frame, color: color)
        //self.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        self.navigationBar.isTranslucent = true
    }
}
