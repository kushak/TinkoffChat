//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by user on 08.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CommunicationManager: NSObject, CommunicatorDelegate {
    
    static let sharedInstance = CommunicationManager()
    
    var comunicator: MultipeerCommunicator
    
    var sessionsArray = [MCSession]()
    
    override init() {
        comunicator = MultipeerCommunicator()
        super.init()
        comunicator.delegate = self
    }
    
    //MARK: ComunicatorDelegate
    //discovering
    func didFoundUser(userID: String, userName: String){
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didFoundUser"), object: nil, userInfo: ["user": userID])
    }
    
    func didLostUser(userID: String){
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didLostUser"), object: nil, userInfo: ["user": userID])
    }
    
    //errors
    func failedToStartBrowsingForUsers(error: Error){
        
    }
    func failedToStartAdvertising(error: Error){
        
    }
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String){
        print(#function)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveMessage"), object: nil, userInfo: ["text": text, "user": fromUser])
    }
    
    func getPeers() -> [Conversation] {
        
        var conversations = [Conversation]()

        let peers = comunicator.peersDictionary.values
        
        for peer in peers {
            let conversation = Conversation()
            conversation.online = true
            conversation.userID = peer.peerID?.displayName
            conversation.name = peer.userName
            conversations.append(conversation)
        }
        
        conversations.sort {
            if $0.date == nil && $1.date == nil {
                return $0.name! < $1.name!
            } else if $0.date == nil {
                return true
            } else if $1.date == nil {
                return false
            } else {
                return $0.date! < $1.date!
            }
        }
        
        return conversations
    }
    
    func sendMessage(text: String, toUser: String) {
        comunicator.sendMessage(string: text, to: toUser) { (bool, error) in
            if bool {
                print("sendMessage complete")
            } else {
                print("sendMessage NOT complete")
            }
        }
    }
}
