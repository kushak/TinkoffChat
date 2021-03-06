//
//  MessageLabel.swift
//  TinkoffChat
//
//  Created by user on 01.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class MessageLabel: UILabel {

    var topInset: CGFloat = 16.0
    var bottomInset: CGFloat = 16.0
    var leftInset: CGFloat = 16.0
    var rightInset: CGFloat = 16.0
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
