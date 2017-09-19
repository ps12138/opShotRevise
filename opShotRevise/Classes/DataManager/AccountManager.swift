//
//  AccountManager.swift
//  opShotRevise
//
//  Created by PSL on 9/18/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import WebKit

protocol AccountManagerDelegate: class {
    func didFinishOAuthFlow(success: Bool, error: Error?)
}


class AccountManager {
    
    weak var delegate: AccountManagerDelegate?
    var hasAccessToken: Bool {
        if accessToken != nil {
            return true
        }
        return false
    }
    
    struct Keys {
        static let requestTokenURL = "https://dribbble.com/oauth/token"
        static let oauthLoginURL = "https://dribbble.com/oauth/authorize"
        static let scope = "public+write"
        static let scopePermission = "public write"
        static let bearer = "bearer"
        static let callBackUrl = "driapicallback"
        
        static let clientId = "c5f84baa3d4096f07768beb612f28203962046bf12671823c2b3da8c6cfbed8a"
        static let clientSecret = "304dd3befbaa17e3e374d1ea01213c95491fdc91b4389a17ddd801c4a417ef08"
        static let publicToken = "a156d6134f4a70f744b0215d74890e0f38e9c60f1d08a80e5c69c900a8aa006f"
        
        static let kUserDefaultAccessToken = "kUserDefaultAccessToken"
    }
    fileprivate let userDefault = UserDefaults.standard
    fileprivate var accessToken: String? {
        get {
            return userDefault.object(forKey: Keys.kUserDefaultAccessToken) as? String
        }
        set {
            userDefault.set(newValue, forKey: Keys.kUserDefaultAccessToken)
        }
    }
    fileprivate var createdAt: Int?
    fileprivate var isRequesting = false
    
    fileprivate func resetAccessToken(to str: String?) {
        self.accessToken = str
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleOAuthCallBack(_:)), name: ReceivedURLCallBackNotification, object: nil)
    }
    
    // sept1: login with login url
    func login(vc: UIViewController) {
        if isRequesting {
            return
        }
        isRequesting = true
        let authUrl = oauth2LoginUrl
        let title = "Login to Dribbble"
        let wkVC = WKViewController(url: authUrl, textTitle: title)
        wkVC.webViewDelegate = self
        vc.navigationController?.pushViewController(wkVC, animated: true)
    }
    
    // sept3: process call back url and request token
    @objc func handleOAuthCallBack(_ notification: NSNotification) {
        
        guard let url = notification.object as? URL else {
            return
        }
        processOAuthCallBack(url: url) { [weak self] (success, error) in
            self?.delegate?.didFinishOAuthFlow(success: success, error: error)
        }
    }
    
    // sept4: logout
    func logout(completion: @escaping () -> ()) {
        resetAccessToken(to: nil)
        let dataTypes = [WKWebsiteDataTypeCookies,
                         WKWebsiteDataTypeLocalStorage,
                         WKWebsiteDataTypeMemoryCache,
                         WKWebsiteDataTypeDiskCache,
                         WKWebsiteDataTypeSessionStorage,
                         WKWebsiteDataTypeWebSQLDatabases,
                         WKWebsiteDataTypeIndexedDBDatabases]
        let dataTypeSet = Set(dataTypes)
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypeSet, modifiedSince: Date.distantPast, completionHandler: completion)
    }
}

fileprivate extension AccountManager {
    
    var oauth2LoginUrl: URL? {
        
        let oauthLoginURL = Keys.oauthLoginURL
        let clientId = Keys.clientId
        let scope = Keys.scope
        
        let authPath = "\(oauthLoginURL)?client_id=\(clientId)&scope=\(scope)"
        guard let authUrl = URL(string: authPath) else {
            assertionFailure("Invalid authPath to URL")
            return  nil
        }
        return authUrl
    }

    func processOAuthCallBack(url: URL, completion: @escaping (Bool, Error?) -> ()) {
        
        guard let code = parseCode(from: url) else {
            completion(false, nil)
            return
        }
        requestToken(code: code) { [weak self] (success, error) in
            self?.isRequesting = false
            completion(success, error)
        }
    }
    
    func parseCode(from url: URL) -> String? {
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        var code: String?
        guard let queryItems = components?.queryItems else {
            return nil
        }
        for queryItem in queryItems {
            if queryItem.name.lowercased() == "code" {
                code = queryItem.value
                break
            }
        }
        return code
    }
    
    func requestToken(code: String, completion: @escaping (Bool, Error?) -> ()) {
        
        let params = [
            "client_id" : Keys.clientId,
            "client_secret" : Keys.clientSecret,
            "code" : code]
        let header = ["Authorization": "appplication/json"]
        
        AFClient().post(urlString: Keys.requestTokenURL, params: params, header: header) { [weak self] (result, error) in
            if let error = error {
                completion(false, error)
            }
            self?.parseAccessToken(object: result, completion: completion)
        }
    }
    
    func parseAccessToken(object: String?, completion: @escaping (Bool, Error?) -> ()) {
        
        guard let object = object else {
            assertionFailure("Invalid response json")
            completion(false, nil)
            return
        }
        
        guard let jsonData = object.data(using: .utf8, allowLossyConversion: false) else {
            assertionFailure("object cannot decode")
            completion(false, nil)
            return
        }
        
        guard let jsonDict = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? [String: Any] else {
            assertionFailure("Invalid respinse json ormat")
            completion(false, nil)
            return
        }
        
        var accessToken: String?
        var createdAt: Int?
        var scope: String = ""
        var type: String = ""
        
        for (key, value) in jsonDict {
            switch key {
            case "access_token":
                accessToken = value as? String
            case "scope":
                scope = (value as? String) ?? ""
            case "token_type":
                type = (value as? String) ?? ""
            case "created_at":
                createdAt = value as? Int
            default:
                print("More key value pair: \(key) - \(value)")
            }
        }
        
        guard scope == Keys.scopePermission, type == Keys.bearer else {
            assertionFailure("Cannot find valid auth permission")
            completion(false, nil)
            return
        }
        
        guard let validAccessToken = accessToken, let validCreatedAt = createdAt else {
            assertionFailure("Cannot find valid accessToken")
            completion(false, nil)
            return
        }
        
        self.accessToken = validAccessToken
        self.createdAt = validCreatedAt
        print("Confirmed access token: \(object)")
        completion(true, nil)
    }
}

// MARK: - WKViewControllerDelegate
extension AccountManager: WKViewControllerDelegate {
    func WKViewDidFinish() { }
    
    func WKViewDidFail() {
        isRequesting = false
    }
    
    func WKViewDidPopBack() {
        isRequesting = false
    }
    
    func WKViewCanBeginRequestingToken() -> Bool {
        if isRequesting {
            return false
        }
        isRequesting = true
        return true
    }
}
