//
//  ProfileViewController.swift
//  opShotRevise
//
//  Created by PSL on 9/7/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit
import MJRefresh

class ProfileViewController: UIViewController {
    // MARK: - Views
    fileprivate weak var tableView: UITableView?
    //fileprivate typealias HomeCell = HomeCollectionViewCell
    
    // MARK: - Properties
    fileprivate var feedManager = FeedShotsManager()
    
    // MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        prepareTableView()
        prepareRefresh()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

fileprivate typealias Utilities = ProfileViewController
fileprivate extension Utilities {
    
    func prepareTableView() {
        let tableView = UITableView(forAutoLayout: ())
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 49, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        self.tableView = tableView
        self.view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func prepareRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(self.refreshAllShots))
        header?.isAutomaticallyChangeAlpha = true
        header?.lastUpdatedTimeLabel.isEnabled = true
        header?.stateLabel.isHidden = true
        header?.beginRefreshing()
        self.tableView?.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(self.loadMoreShots))
        footer?.isAutomaticallyChangeAlpha = true
        footer?.setTitle("No More Shots", for: .noMoreData)
        self.tableView?.mj_footer = footer
    }
    
    @objc func refreshAllShots() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.resetNoMoreData()
    }
    
    @objc func loadMoreShots() {
        self.tableView?.mj_header.endRefreshing()
        self.tableView?.mj_footer.endRefreshingWithNoMoreData()
    }
}
