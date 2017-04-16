//
//  Message.swift
//  TinkoffChat
//
//  Created by user on 27.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var forUser: String?
    var text: String?
    var isInputMessage: Bool?
    var date: Date?
    
    init(text: String?, isInputMessage: Bool) {
        self.text = text
        self.isInputMessage = isInputMessage
    }
}
