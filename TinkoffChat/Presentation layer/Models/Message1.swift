//
//  Message1.swift
//  TinkoffChat
//
//  Created by user on 13.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Message1 {
    static func insertMessage(text: String, conversation: Conversation1?, in context: NSManagedObjectContext) -> Message1? {
        
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message1", into: context) as? Message1 {
            message.conversation = conversation
            message.text = text
            message.messageId = Message1.generateID()
            message.date = NSDate(timeIntervalSinceNow: 0.0)
            
            return message
        }
        return nil
    }
    
    static func generateID() -> String {
        var timeStamp: String {
            return "\(arc4random())" + "\(Date().timeIntervalSince1970)" + "\(arc4random())"
        }
        return String(timeStamp.hashValue)
    }
}
