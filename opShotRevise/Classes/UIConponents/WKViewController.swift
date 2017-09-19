//
//  WKViewController.swift
//  opShotRevise
//
//  Created by PSL on 9/18/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol WKViewControllerDelegate: class {
    func WKViewDidFinish()
    func WKViewDidFail()
    func WKViewDidPopBack()
    func WKViewCanBeginRequestingToken() -> Bool
}

class WKViewController: UIViewController {
    
    // MARK: - Model
    var url: URL?
    var textTitle: String?
    
    // MARK: - View
    lazy var webview = WKWebView()
    lazy var btnDone = UIBarButtonItem()
    lazy var progBar = UIProgressView()
    
    // MARK: - delegate
    var webViewDelegate: WKViewControllerDelegate?
    
    // MARL: - Constants
    internal struct Constants {
        static let progressKey = "estimatedProgress"
    }
    
    // MARK: - Init
    init(url: URL?, textTitle: String?) {
        super.init(nibName: nil, bundle: nil)
        self.textTitle = textTitle
        self.url = url
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init UINav
        prepareNav()
        self.automaticallyAdjustsScrollViewInsets = false
        webview.scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        // creat web request
        if let validURL = url {
            let request = URLRequest(url: validURL)
            // load request
            webview.load(request)
            // add wkwebview as subView
            self.view.addSubview(webview)
        }
        webview.navigationDelegate = self
        webview.autoPinEdgesToSuperviewEdges()
        // init progress
        initLoadingProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        removeProgressKVO()
    }
}

extension WKViewController {

    func prepareNav() {
        self.navigationController?.settingTransparentBar()
        btnDone = UIBarButtonItem(
            title: "Back",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(self.didTapBack)
        )
        self.navigationItem.leftBarButtonItem = btnDone
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    func didTapBack() {
        self.webViewDelegate?.WKViewDidPopBack()
        self.navigationController?.popViewController(animated: true)
    }
}

extension WKViewController: WKNavigationDelegate {
    
    //MARK: - WKNavigationDelegate
    // finish loading url
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("wkVC: didFinish WKWebView")
        webViewDelegate?.WKViewDidFinish()
        
    }
    // fail to load url
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("wkVC: didFail WKWebView")
        print("wkVC: error: \(error)")
        webViewDelegate?.WKViewDidFail()
    }
    // handle callBack scheme
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        guard let urlScheme = url.scheme, urlScheme == AccountManager.Keys.callBackUrl else {
            decisionHandler(.allow)
            return
        }
        guard let status = webViewDelegate?.WKViewCanBeginRequestingToken(), status else {
            decisionHandler(.allow)
            return
        }
        NotificationCenter.default.post(name: ReceivedURLCallBackNotification, object: url)
        decisionHandler(.cancel)
    }
}

// MARK: - loading progress
extension WKViewController {
    
    // init in didLoad
    func initLoadingProgress() {
        let origin = CGPoint(x: 0, y: 0)
        let size = CGSize(width: self.view.frame.width, height: 50)
        let frame = CGRect(origin: origin, size: size)
        progBar = UIProgressView(frame: frame)
        progBar.progress = 0.0
        progBar.tintColor = UIColor.red
        self.webview.addSubview(progBar)
        
        // addKVO
        addKVO()
    }
    
    // MARK: - handle KVO
    //The WKWebView class is key-value observing (KVO) compliant for this property.
    
    // addKVO in didLoad
    func addKVO() {
        self.webview.addObserver(
            self,
            forKeyPath: Constants.progressKey,
            options: NSKeyValueObservingOptions.new,
            context: nil
        )
    }
    
    func removeProgressKVO() {
        self.webview.removeObserver(self, forKeyPath: Constants.progressKey)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
        ) {
        if keyPath == Constants.progressKey {
            self.progBar.alpha = 1.0
            let estiProgress = Float(webview.estimatedProgress)
            progBar.setProgress(estiProgress, animated: true)
            //max progress value: 1.0
            if estiProgress >= 1.0 {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.3,
                    options: UIViewAnimationOptions.curveEaseInOut,
                    animations: { () -> Void in
                        self.progBar.alpha = 0.0
                },
                    completion: { (finished:Bool) -> Void in
                        self.progBar.progress = 0.0
                }
                )
            }
        }
    }
}
