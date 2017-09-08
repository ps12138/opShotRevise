//
//  DataManagerKeys.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation

enum FeedContentType: Int {
    case recent
    case popular
    case animated
    case teams
    case debuts
    case followed
    case liked
    case buckets
    
    var title: String {
        switch self {
        case .recent:
            return "Recent"
        case .popular:
            return "Popular"
        case .animated:
            return "Animated"
        case .teams:
            return "Teams"
        case .debuts:
            return "Debuts"
        case .followed:
            return "Followed"
        case .liked:
            return "Liked"
        case .buckets:
            return "Buckets"
        }
    }
}
