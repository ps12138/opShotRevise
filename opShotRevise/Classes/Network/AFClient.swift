//
//  AFClient.swift
//  opShotRevise
//
//  Created by PSL on 9/18/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import Alamofire


class AFClient {
    
    func post(urlString: String,
              params: [String: Any]? = nil,
              header: [String: String]? = nil,
              completion: @escaping (String?, Error?) -> ()) {
        
        let client: DataRequest = Alamofire.request(urlString, method: Alamofire.HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: header)
        client.responseString { (response) in
            if response.result.isSuccess {
                completion(response.result.value, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}
