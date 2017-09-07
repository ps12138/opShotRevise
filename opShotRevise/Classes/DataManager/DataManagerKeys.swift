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
    case mostComment
    
    var title: String {
        switch self {
        case .recent:
            return "Recent"
        case .popular:
            return "Popular"
        case .mostComment:
            return "Most Comment"
        }
    }
}
