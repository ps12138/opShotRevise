//
//  TileMenuViewController.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit

class TitleMenuViewController: UIViewController {

    fileprivate var titlesView: TitleView!
    fileprivate weak var contentView: UIScrollView?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(childVC: [UIViewController]) {
        self.init()
        var titles:[String] = []
        for vc in childVC {
            titles.append(vc.title ?? "null")
            self.addChildViewController(vc)
        }
        titlesView = TitleView(titles: titles, titleColor: .black, fontSize: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
}

private typealias Utilities = TitleMenuViewController
extension Utilities {
    func prepareUI() {
        self.view.backgroundColor = .white
        setupContentView()
        setupTitlesView()
        setupAutoLayout()
    }
    
    private func setupTitlesView() {
        self.titlesView.delegate = self
        self.navigationItem.titleView = titlesView
    }
    private func setupContentView() {
        self.automaticallyAdjustsScrollViewInsets = false
        let contentView = UIScrollView()
        contentView.isPagingEnabled = true
        self.view.insertSubview(contentView, at: 0)
        contentView.contentSize = CGSize(width: self.view.bounds.size.width*CGFloat(self.childViewControllers.count), height: 0)
        contentView.frame = self.view.frame
        contentView.delegate = self
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        self.contentView = contentView
        self.scrollViewDidEndScrollingAnimation(contentView)
    }
    
    private func setupAutoLayout() {
        titlesView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 40)
    }
}

extension TitleMenuViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let countOfVC = self.childViewControllers.count
        let index = (Int)(scrollView.contentOffset.x/scrollView.bounds.size.width)
        
        let vc = self.childViewControllers[index]
        vc.view.frame.origin.x = scrollView.contentOffset.x
        scrollView.addSubview(vc.view)
        
        if index + 1 < countOfVC {
            let nextVC = self.childViewControllers[index+1]
            nextVC.view.frame.origin.x = scrollView.contentOffset.x + scrollView.bounds.size.width
            scrollView.addSubview(nextVC.view)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
        var index = (Int)(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if index >= 1 {
            index += 1 // consider indicator of titlesView
        }
        guard let button = self.titlesView.subviews[index] as? UIButton else {
            assertionFailure("Should convert to button")
            return
        }
        titlesView.titleClick(button: button)
    }
}

extension TitleMenuViewController: TitleViewDelegate {
    func click(buttonTag:Int) {
        var offset = self.contentView?.contentOffset
        offset?.x = CGFloat(buttonTag) * self.view.bounds.width
        self.contentView?.setContentOffset(offset!, animated: true)
    }
}
