//
//  HomeCellViewModel.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation

import Foundation
import UIKit


fileprivate let columnSpacing = CHTCollectionViewWaterfallLayout.Constants.columnSpacing
fileprivate let itemSpacing = CHTCollectionViewWaterfallLayout.Constants.columnSpacing
fileprivate let columnNum = CHTCollectionViewWaterfallLayout.Constants.collectionColumnNum

fileprivate let maxHeightOfDesc: CGFloat = 75

class HomeCellViewModel {
    var contentImageUrl: URL
    var isAnimated: Bool
    var title: String
    var desc: String
    var userAvatarImageUrl: URL
    var userName: String
    var location: String
    var itemSize: CGSize
    
    init(mock: Bool) {
        self.contentImageUrl = URL(string: "https://d13yacurqjgara.cloudfront.net/users/1/screenshots/471756/sasquatch.png")!
        self.isAnimated = true
        self.title = "Sasquatch"
        if mock {
            self.desc = "Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something.Quick, messy, five minute sketch of something that might become a fictional something."
        }
        else {
            self.desc =  "Quick, messy, five minute sketch"
        }
        
        self.userAvatarImageUrl = URL(string: "https://d13yacurqjgara.cloudfront.net/users/1/avatars/normal/dc.jpg?1371679243")!
        self.userName = "Dan Cederholm"
        self.location = "📍New Fuxk"
        self.itemSize = type(of: self).calculateItemSize(desc: desc)
        print("size: \(itemSize)")
    }
    
    static func calculateItemSize(desc: String) -> CGSize {
        let contentImageTop: CGFloat = 5
        let contentImageBottom: CGFloat = 5
        let titleBottom: CGFloat = 5
        let descBottom: CGFloat = 5
        let avatarBottom: CGFloat = 5
        
        let titleHeight: CGFloat = 20
        let avatarHeight: CGFloat = 32
        let descMargin: CGFloat = 5
        
        let itemWidth = (ScreenWidth - columnSpacing * CGFloat(columnNum - 1) - itemSpacing * 2) / 2
        
        let imageHeight = itemWidth * 3 / 4
        let descHeight: CGFloat = desc.height(
            withConstrainedWidth: itemWidth - descMargin * 2,
            font: UIFont.descFont)
        let validDescHeight: CGFloat = descHeight > maxHeightOfDesc ? maxHeightOfDesc : descHeight
        
        let itemHeight = contentImageTop + contentImageBottom + titleBottom + descBottom + avatarBottom + imageHeight + titleHeight + validDescHeight + avatarHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
}









