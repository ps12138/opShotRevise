//
//  CurrentUserProfileViewController.swift
//  opShotRevise
//
//  Created by PSL on 9/9/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit
import SVProgressHUD

class CurrentUserProfileViewController: UIViewController {

    fileprivate let accountManager = AccountManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let rightItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.didTapLogout))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func didTapLogout() {
        SVProgressHUD.show()
        accountManager.logout { 
            SVProgressHUD.show(withStatus: "Success logout")
            SVProgressHUD.dismiss(withDelay: 1)
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
}
