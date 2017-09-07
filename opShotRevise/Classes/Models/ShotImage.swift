//
//  ShotPicture.swift
//  Dribbble
//
//  Created by Hetian Yang on 5/25/17.
//  Copyright © 2017 Hetian Yang. All rights reserved.
//

import Foundation
import ObjectMapper

class ShotImage {
    var hidpi: String?
    var normal: String?
    var teaser: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        hidpi  <- map["hidpi"]
        normal <- map["normal"]
        teaser <- map["teaser"]
    }
}
