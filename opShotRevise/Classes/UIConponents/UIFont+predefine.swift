//
//  UIFont.swift
//  opShotRevise
//
//  Created by PSL on 9/7/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static var titleFont: UIFont {
        return UIFont(name: "PingFangSC-Medium", size: 15)!
    }
    static var descFont: UIFont {
        return UIFont.systemFont(ofSize: 13)
    }
}
