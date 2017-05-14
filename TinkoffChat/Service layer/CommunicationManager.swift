//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by user on 08.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicationManager: NSObject, CommunicatorDelegate {
    
    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
    let multipeerCommunicator = MultipeerCommunicator()
    
    override init() {
        super.init()
        multipeerCommunicator.delegate = self
    }
    
    //discovering
    func didFoundUser(userID: String, userName: String) {
        print("FOUND \(userID)")
        if let user = User.findOrInsertUser(id: userID, in: coreDataStack.saveContext!) {
            user.isOnline = true
            user.name = userName
            user.userId = userID
            user.conversation?.isOnline = true
            coreDataStack.performSave(context: coreDataStack.saveContext!, completionHandler: nil)
            print("AND SAVE")
        }
    }
    
    func didLostUser(userID: String) {
        print("LOST \(userID)")
        if let user = User.findOrInsertUser(id: userID, in: coreDataStack.saveContext!) {
            user.isOnline = false
            user.conversation?.isOnline = false
            coreDataStack.performSave(context: coreDataStack.saveContext!, completionHandler: nil)
            print("AND SAVE")
        }
    }
    
    //errors
    func failedToStartBrowsingForUsers(error: Error) {
        print(#function)
    }
    func failedToStartAdvertising(error: Error) {
        print(#function)
    }
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let user = User.findOrInsertUser(id: fromUser, in: coreDataStack.saveContext!) {
            user.isOnline = true
            if let message = Message1.insertMessage(text: text, conversation: user.conversation, in: coreDataStack.saveContext!) {
                user.addToOutgoingMessages(message)
            }
            coreDataStack.performSave(context: coreDataStack.saveContext!, completionHandler: nil)
        }
    }
    
//    let coreDataStack: CoreDataStack = (UIApplication.shared.delegate as! AppDelegate).coreDataStack
//    
//    static let sharedInstance = CommunicationManager()
//    
//    var comunicator: MultipeerCommunicator
//    
//    var sessionsArray = [MCSession]()
//    
//    override init() {
//        comunicator = MultipeerCommunicator()
//        super.init()
//        comunicator.delegate = self
//    }
//    
//    //MARK: ComunicatorDelegate
//    //discovering
//    func didFoundUser(userID: String, userName: String){
//        print(#function)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didFoundUser"), object: nil, userInfo: ["user": userID])
//    }
//    
//    func didLostUser(userID: String){
//        print(#function)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLostUser"), object: nil, userInfo: ["user": userID])
//    }
//    
//    //errors
//    func failedToStartBrowsingForUsers(error: Error){
//        
//    }
//    func failedToStartAdvertising(error: Error){
//        
//    }
//    
//    //messages
//    func didReceiveMessage(text: String, fromUser: String, toUser: String){
//        print(#function)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveMessage"), object: nil, userInfo: ["text": text, "user": fromUser])
//    }
//    
//    func getPeers() -> [Conversation] {
//        
//        var conversations = [Conversation]()
//
//        let peers = comunicator.peersDictionary.values
//        
//        for peer in peers {
//            let conversation = Conversation()
//            conversation.online = true
//            conversation.userID = peer.peerID?.displayName
//            conversation.name = peer.userName
//            conversations.append(conversation)
//        }
//        
//        conversations.sort {
//            if $0.date == nil && $1.date == nil {
//                return $0.name! < $1.name!
//            } else if $0.date == nil {
//                return true
//            } else if $1.date == nil {
//                return false
//            } else {
//                return $0.date! < $1.date!
//            }
//        }
//        
//        return conversations
//    }
//    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success : Bool,_ error: Error?) -> ())?) {
        multipeerCommunicator.sendMessage(string: string, to: userID, completionHandler: completionHandler)
    }
}
