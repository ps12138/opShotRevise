//
//  Common.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import UIKit

var ScreenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var ScreenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

let NavBarColor = UIColor(white: 1, alpha: 0.7)
let MainColor = UIColor.white
let SecondaryColor = UIColor.red

let ReceivedURLCallBackNotification = NSNotification.Name(rawValue: "kReceivedURLCallBackNotification")
