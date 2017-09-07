//
//  MainNavigationController.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
    }
    
    private func setupColor() {
        self.navigationBar.tintColor = UIColor.black
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let color = NavBarColor
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .black
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            backBtn.setImage(UIImage(named:"back"), for: .normal)
            backBtn.addTarget(self, action: #selector(self.back), for: .touchUpInside)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        }
        self.interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func back() {
        self.popViewController(animated: true)
    }
}
