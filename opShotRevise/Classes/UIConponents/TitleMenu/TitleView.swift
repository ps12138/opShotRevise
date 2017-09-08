//
//  TitleView.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import UIKit

protocol TitleViewDelegate: class {
    func click(buttonTag:Int)
}

class TitleView: UIView {
    
    internal weak var delegate: TitleViewDelegate?
    
    internal weak var activeButton: UIButton?
    private var indicator: UIView!
    private weak var constraint: NSLayoutConstraint?
    private weak var widthConstraint: NSLayoutConstraint?
    
    var titleArray: [String] = []
    var titleFont: UIFont?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(titles:[String], titleColor:UIColor, fontSize:CGFloat){
        self.init(frame: CGRect())
        
        self.titleArray = titles
        var lastButton:UIButton?
        var tag = 0
        titleFont = UIFont.boldSystemFont(ofSize: fontSize)
        for title in titles {
            
            let button = UIButton(title: title, titleColor, fontSize)
            button.tag = tag
            button.addTarget(self, action: #selector(self.titleClick), for: .touchUpInside)
            self.addSubview(button)
            
            if let lastButton = lastButton {
                button.autoPinEdge(.leading, to: .trailing, of: lastButton)
                button.autoMatch(.width, to: .width, of: lastButton)
            }
            else {
                button.autoPinEdge(toSuperviewEdge: .leading)
                button.isEnabled = false
                activeButton = button
                
                indicator = UIView()
                self.addSubview(indicator)
                indicator.backgroundColor = SecondaryColor
                indicator.alpha = 0.95
                indicator.autoSetDimension(.height, toSize: 4.0)
                widthConstraint = indicator.autoSetDimension(.width, toSize: 40.0)
                //                indicator.layer.cornerRadius = 2.0
                //                indicator.clipsToBounds = true
                indicator.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
                constraint = indicator.autoAlignAxis(.vertical, toSameAxisOf: button)
            }
            
            button.autoPinEdge(toSuperviewEdge: .bottom)
            button.autoPinEdge(toSuperviewEdge: .top, withInset: -6)
            button.autoSetDimension(.width, toSize: ScreenWidth/4)
            lastButton = button
            tag += 1
        }
        
        //lastButton?.autoPinEdge(toSuperviewEdge: .trailing)
    }
    
    @objc func titleClick(button:UIButton) {
        activeButton?.isEnabled = true
        button.isEnabled = false
        activeButton = button
        constraint?.autoRemove()
        constraint = self.indicator?.autoAlignAxis(.vertical, toSameAxisOf: button)
        let titleString = self.titleArray[button.tag]
        
        widthConstraint?.autoRemove()
        widthConstraint = indicator.autoSetDimension(.width, toSize: titleString.width(withConstraintedHeight: 18.0, font: self.titleFont!))
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        delegate?.click(buttonTag: button.tag)
    }
    
}
