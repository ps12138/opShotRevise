//
//  HomeViewController.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit
import PureLayout
import MJRefresh

class HomeViewController: UIViewController {
    
    // MARK: - Models
    var shots: [HomeCellViewModel] = []

    // MARK: - Views
    fileprivate weak var collectionView: UICollectionView?
    fileprivate typealias HomeCell = HomeCollectionViewCell
    
    // MARK: - Properties
    fileprivate var contentType: FeedContentType = .recent
    fileprivate var feedManager = FeedShotsManager()
    fileprivate var isFirstApeared: Bool = true
    
    // MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: FeedContentType) {
        self.init(nibName: nil, bundle: nil)
        self.contentType = type
        self.title = type.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        prepareCollectionView()
        prepareRefresh()
        mock()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstApeared {
            isFirstApeared = false
            self.collectionView?.mj_header.beginRefreshing()
        }
    }
    
    func mock() {
        shots = [HomeCellViewModel.init(mock: true),
                 HomeCellViewModel.init(mock: false),
                 HomeCellViewModel.init(mock: true),
                 HomeCellViewModel.init(mock: false),
                 HomeCellViewModel.init(mock: true),
                 HomeCellViewModel.init(mock: false),
                 HomeCellViewModel.init(mock: true)]
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HomeCell
        cell.displayObject = shots[indexPath.row]
        return cell
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout
extension HomeViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView (_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        let shot = shots[indexPath.row]
        return shot.itemSize
    }
}

fileprivate typealias Utilities = HomeViewController
fileprivate extension Utilities {
    
    func prepareCollectionView() {

        let layout = CHTCollectionViewWaterfallLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(cellType: HomeCell.self)
        
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    func prepareRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshAllShots))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isEnabled = true
        header?.stateLabel.isHidden = true
        self.collectionView?.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreShots))
        footer?.isAutomaticallyChangeAlpha = true
        footer?.setTitle("No More Shots", for: .noMoreData)
        self.collectionView?.mj_footer = footer
    }
    
    @objc func refreshAllShots() {
        self.collectionView?.mj_header.endRefreshing()
        self.collectionView?.mj_footer.resetNoMoreData()
    }
    
    @objc func loadMoreShots() {
        self.collectionView?.mj_header.endRefreshing()
        self.collectionView?.mj_footer.endRefreshingWithNoMoreData()
    }
}
