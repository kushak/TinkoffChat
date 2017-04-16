//
//  Conversation.swift
//  TinkoffChat
//
//  Created by user on 26.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class Conversation: NSObject {

    var imageURL: String?
    var name: String?
    var userID: String?
    var messages = [Message]()
    var date: Date?
    var online: Bool?
    var hasUnreadMessage: Bool?
    
}
