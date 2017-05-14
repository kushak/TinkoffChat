//
//  StorageService.swift
//  TinkoffChat
//
//  Created by user on 17.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class StorageService: NSObject {
//    
//    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
//    let multipeerCommunicator = MultipeerCommunicator()
//    
//    override init() {
//        super.init()
//        multipeerCommunicator.delegate = self
//    }
//    
//    //discovering
//    func didFoundUser(userID: String, userName: String) {
//        print("FOUND \(userID)")
//        if let user = User.findOrInsertUser(id: userID, in: coreDataStack.saveContext!) {
//            user.isOnline = true
//            user.name = userName
//            user.userId = userID
//            user.conversation?.isOnline = true
//            coreDataStack.performSave(context: coreDataStack.saveContext!, completionHandler: nil)
//            print("AND SAVE")
//        }
//    }
//    
//    func didLostUser(userID: String) {
//        print("LOST \(userID)")
//        if let user = User.findOrInsertUser(id: userID, in: coreDataStack.saveContext!) {
//            user.isOnline = false
//            user.conversation?.isOnline = false
//            coreDataStack.performSave(context: coreDataStack.saveContext!, completionHandler: nil)
//            print("AND SAVE")
//        }
//    }
//    
//    //errors
//    func failedToStartBrowsingForUsers(error: Error) {
//        print(#function)
//    }
//    func failedToStartAdvertising(error: Error) {
//        print(#function)
//    }
//    
//    //messages
//    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
//        if let user = User.findOrInsertUser(id: fromUser, in: coreDataStack.saveContext!) {
//            user.isOnline = true
//            if let message = Message1.insertMessage(text: text, conversation: user.conversation, in: coreDataStack.saveContext!) {
//                user.addToOutgoingMessages(message)
//            }
//            coreDataStack.performSave(context: coreDataStack.saveContext!, completionHandler: nil)
//        }
//    }
}

