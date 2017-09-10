//
//  MainTabBarController.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainTabBarController: ESTabBarController {

    var indicatorView: UIView!
    var indicatorColor: UIColor = SecondaryColor
    let slidingBarWidthRatio: CGFloat = 0.25
    let edgeSelectedHeight: CGFloat = 4
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareViewControllers()
        setupTabBarBackground()
        prepareTabBarIndicator()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        super.tabBar(tabBar, didSelect: item)
        handleSelected(item: item)
    }
}

// MARK: - Utilities
fileprivate typealias Utilities = MainTabBarController
fileprivate extension Utilities {
    func prepareViewControllers() {
        
        let recentHomeVC = HomeViewController(type: .recent)
        let popularHomeVC = HomeViewController(type: .popular)
        let animatedHomeVC = HomeViewController(type: .animated)
        //let debutsHomeVC = HomeViewController(type: .debuts)
        let teamsHomeVC = HomeViewController(type: .teams)
        
        let menuHomeVC = TitleMenuViewController(childVC: [recentHomeVC, popularHomeVC, animatedHomeVC, teamsHomeVC])
        let homeNav = MainNavigationController(rootViewController: menuHomeVC)
        
        let followedExploreVC = HomeViewController(type: .followed)
        let likedExploreVC = HomeViewController(type: .liked)
        let bucketsExploreVC = HomeViewController(type: .buckets)
        let menuExploreVC = TitleMenuViewController(childVC: [followedExploreVC, likedExploreVC, bucketsExploreVC])
        let exploreNav = MainNavigationController(rootViewController: menuExploreVC)
        
        let profileVC = ProfileViewController(title: "Profile")
        let profileNav = MainNavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = ESTabBarItem(
            BouncesContentView(),
            title: nil,
            image: UIImage(named: "HomeDeselected"),
            selectedImage: UIImage(named: "HomeSelected"))
        
        exploreNav.tabBarItem = ESTabBarItem(
            BouncesContentView(),
            title: nil,
            image: UIImage(named: "ExploreDeselected"),
            selectedImage: UIImage(named: "ExploreSelected"))
        
        profileNav.tabBarItem = ESTabBarItem(
            BouncesContentView(),
            title: nil,
            image: UIImage(named: "ProfileDeselected"),
            selectedImage: UIImage(named: "ProfileSelected"))
        
        viewControllers = [homeNav, exploreNav, profileNav]
    }
    
    func setupTabBarBackground() {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let color = NavBarColor
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.tabBar.backgroundImage = image
        //self.tabBar.shadowImage = UIImage()
    }
    
    func prepareTabBarIndicator() {
        guard let totalCount = self.tabBar.items?.count else {
            assertionFailure("Error: invalid sequence in viewDidLoad")
            return
        }
        addSelectedView(startingIndex: 0, total: totalCount, totalWidth: self.tabBar.bounds.width)
    }
    
    /// selected animation
    fileprivate func addSelectedView(
        startingIndex index: Int,
        total totalCount: Int,
        totalWidth: CGFloat)
    {
        let sectionWidth = totalWidth / CGFloat(totalCount)
        let slidingBarWidth = sectionWidth * slidingBarWidthRatio
        let startingX = CGFloat(index) * sectionWidth + (sectionWidth - slidingBarWidth) / 2
        
        let frame = CGRect(
            x: startingX,
            y: self.tabBar.frame.height - edgeSelectedHeight - 1,
            width: slidingBarWidth,
            height: edgeSelectedHeight
        )
        let indicatorView = UIView(frame: frame)
        indicatorView.backgroundColor = indicatorColor
        self.tabBar.addSubview(indicatorView)
        self.indicatorView = indicatorView
    }
    /// animated move
    fileprivate func handleSelected(item: UITabBarItem) {
        guard let indicatorView = self.indicatorView else {
            return
        }
        guard let totalCount = tabBar.items?.count,
            let selectedIndex = tabBar.items?.index(of: item) else {
                return
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseOut, animations: {
            let newX = self.getOrigin(fromIndex: selectedIndex, total: totalCount)
            indicatorView.frame.origin.x = newX
        }, completion:nil)
    }
    
    // calculate origin point x
    fileprivate func getOrigin(fromIndex index: Int, total totalCount: Int) -> CGFloat {
        let totalWidth = self.tabBar.frame.width
        let sectionWidth = totalWidth / CGFloat(totalCount)
        let slidingBarWidth = sectionWidth * slidingBarWidthRatio
        let startingX = CGFloat(index) * sectionWidth + (sectionWidth - slidingBarWidth) / 2
        return startingX
    }
}
