//
//  HomeCollectionViewCell.swift
//  Dribbble
//
//  Created by Hetian Yang on 9/5/17.
//  Copyright © 2017 Hetian Yang. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var isAnimatedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var displayObject: HomeCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userAvatarImageView.layer.cornerRadius = 16
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.contentMode = .scaleAspectFill
        
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.layer.cornerRadius = 10
        contentImageView.layer.masksToBounds = true
        
        userAvatarImageView.image = UIImage(named: "UserAvatarPlaceHolder")
        contentImageView.image = UIImage(named: "ContentImagePlaceHolder")
    }
    
    func updateUI() {
        guard let displayObject = displayObject else {
            userAvatarImageView.image = UIImage(named: "UserAvatarPlaceHolder")
            contentImageView.image = UIImage(named: "ContentImagePlaceHolder")
            return
        }
        
        contentImageView.sd_setImage(with: displayObject.contentImageUrl)
        isAnimatedLabel.isHidden = !displayObject.isAnimated
        titleLabel.text = displayObject.title
        descLabel.text = displayObject.desc
        //userAvatarImageView.sd_setImage(with: displayObject.userHeadImageUrl)
        userNameLabel.text = displayObject.userName
        locationLabel.text = displayObject.location
    }

}
