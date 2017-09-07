//
//  String.swift
//  opShotRevise
//
//  Created by PSL on 9/6/17.
//  Copyright © 2017 PSL. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
    
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - add method for check blank string, ignoring white space
extension String {
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
}

// MARK: - get number of chars in trimmed string, no leading/trailing/1+ whitespace in the middle
extension String {
    
    func validString(with length: Int) -> String? {
        if length < 0 {
            return nil
        }
        let trimmedStr = trimmedChars
        if trimmedStr.characters.count != length {
            return nil
        }
        return trimmedStr
    }
    
    func validString(from smallNum: Int, to largeNum: Int, trimmed: Bool = false) -> String? {
        if smallNum < 0 || largeNum < 0 || smallNum > largeNum {
            return nil
        }
        let trimmedStr = trimmed ? trimWhiteSpace(self) : self
        let number = trimmedStr.numberOfChars
        if number < smallNum {
            return nil
        }
        if number > largeNum {
            return nil
        }
        return trimmedStr
    }
    
    var trimmedChars: String {
        return trimWhiteSpace(self)
    }
    
    var numberOfTrimmedChars: Int {
        let trimmedStr = trimWhiteSpace(self)
        let number = trimmedStr.numberOfChars
        return number
    }
    
    var numberOfChars: Int {
        return numberOfChars(self)
    }
    
    private func trimWhiteSpace(_ str: String) -> String{
        let pattern = "^\\s+|\\s+$|\\s+(?=\\s)"
        let trimmed = str.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
        return trimmed
    }
    
    private func numberOfChars(_ str: String) -> Int {
        var number = 0
        guard str.characters.count > 0 else {return 0}
        
        for i in 0..<str.characters.count {
            let c: unichar = (str as NSString).character(at: i)
            
            if (c >= 0x4E00) {
                number += 2
            }else {
                number += 1
            }
        }
        return number
    }
}
