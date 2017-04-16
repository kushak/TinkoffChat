//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by user on 08.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class Peer {
    var peerID: MCPeerID?
    var displayName: String?
    var session: MCSession?
    var userName: String?
}

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

protocol Communicator {
    
    var online: Bool {get set}
    
    weak var delegate: CommunicatorDelegate? {get set}
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}

//class MultipeerCommunicator: NSObject, Communicator, MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate, MCSessionDelegate {
//
//    let serviceType = "tinkoff-chat"
//    
//    var online: Bool
//
//    weak var delegate: ComunicatorDelegate?
//    
//    var advertiser: MCNearbyServiceAdvertiser
//    var browser: MCNearbyServiceBrowser
//    var myPeerID: MCPeerID
//    
//    //var mySession: MCSession
//    
//    var peersDictionary = [String:Peer]()
//    
//    override init() {
//        online = true
//        myPeerID = MCPeerID(displayName: "vbb")
//        //mySession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
//        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["userBane":"oShipulin"], serviceType: serviceType)
//        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
//        super.init()
//        //mySession.delegate = self
//        advertiser.delegate = self
//        browser.delegate = self
//        startSearchUsers()
//    }
//    
//    func startSearchUsers() {
//        advertiser.startAdvertisingPeer()
//        browser.startBrowsingForPeers()
//    }
//    
//    func stopSearchUsers() {
//        advertiser.stopAdvertisingPeer()
//        browser.stopBrowsingForPeers()
//    }
//    
//    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
////        let messageDic = ["eventType": "TextMessage",
////                    "messageId": generatedMessageId(),
////                    "text": string]
////        do {
////            let messageData = try JSONSerialization.data(withJSONObject: messageDic, options: .prettyPrinted)
////            let session = peersDictionary[userID]?.0
////            try session?.send(messageData, toPeers: [session!.connectedPeers.last!], with: .reliable)
////            if (completionHandler != nil) {
////                completionHandler!(true, nil)
////            }
////        } catch {
////            print(error.localizedDescription)
////            if (completionHandler != nil) {
////                completionHandler!(true, error)
////            }
////        }
//    }
//    
//    func generatedMessageId() -> String {
//        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
//        return string!
//    }
//    
//    //MARK: MCNearbyServiceAdvertiserDelegate
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        print("didNotStartAdvertisingPeer")
//    }
//    // Incoming invitation request.  Call the invitationHandler block with YES
//    // and a valid session to connect the inviting peer to the session.
//    // Запрос входящего приглашения. Вызовите блок приглашенияHandler с помощью YES
//    // и действительный сеанс для подключения приглашаемого партнера к сеансу.
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        var session: MCSession
//        if peersDictionary[peerID.displayName] == nil {
//            session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
//            session.delegate = self
//            let peer = Peer()
//            peer.session = session
//            peer.displayName = peerID.displayName
//            peersDictionary[peerID.displayName] = peer
//        } else {
//            session = (peersDictionary[peerID.displayName]?.session)!
//        }
//        print("INVITATION")
//        invitationHandler(true, session)
//    }
//    
//    //MARK: MCNearbyServiceBrowserDelegate
//    // A nearby peer has stopped advertising.
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        if peersDictionary[peerID.displayName] != nil {
//            peersDictionary.removeValue(forKey: peerID.displayName)
//        }
//        print("Lost peer: \(peerID.displayName)")
//        peersDictionary[peerID.displayName] = nil
//        delegate?.didLostUser(userID: peerID.displayName)
//    }
//    
//    // Browsing did not start due to an error.
//    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
//        delegate?.failedToStartBrowsingForUsers(error: error)
//    }
//    
//    // Found a nearby advertising peer.
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        
//        if let userName = info?["userName"] {
//            var session: MCSession
//            if peersDictionary[peerID.displayName] == nil {
//                session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
//                session.delegate = self
//                let peer = Peer()
//                peer.session = session
//                peer.displayName = peerID.displayName
//                peer.userName = userName
//                peersDictionary[peerID.displayName] = peer
//            } else {
//                peersDictionary[peerID.displayName]?.userName = userName
//                session = (peersDictionary[peerID.displayName]?.session)!
//            }
//            print("Found peer: \(peerID.displayName)(\(userName))")
//            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
//            delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
//            print(advertiser.delegate!)
//        }
//    }
//    
//    //MARK: MCSessionDelegate
//    // Remote peer changed state.
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        switch state {
//        case .notConnected:
//            print("\(peerID.displayName) state: NOT CONNECTED")
//            
////            if peersDictionary[peerID.displayName] != nil {
////                peersDictionary.removeValue(forKey: peerID.displayName)
////            }
//        case .connected:
//            print("\(peerID.displayName) state: CONNECTED")
//            
////            peersDictionary[peerID.displayName] = session
//        default:
//            break
//        }
//    }
//    
//    // Received data from remote peer. Полученные данные от удаленного партнера
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
////        do {
////            let json = try JSONSerialization.jsonObject(with: data, options: [])
////            delegate?.didReceiveMessage(text: json as! String, fromUser: peerID.displayName, toUser: nil)
//            let recievedData = String(data: data, encoding: String.Encoding.utf8)
//            print("didRecieveData \(recievedData!)")
////        } catch {
////            print(error.localizedDescription)
////        }
//    }
//    
//    // Received a byte stream from remote peer.
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
//    
//    // Received a byte stream from remote peer.
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
//    
//    // Начало получения ресурса от удаленной точки.
//    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) { }
//    
//    // Завершено получение ресурса от удаленного партнера и сохранение содержимого
//    // во временном месте - приложение отвечает за перемещение файла
//    // в постоянное место в его песочнице.
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) { }
//}



class MultipeerCommunicator: NSObject, Communicator{
    
    private let userServiceType = "tinkoff-chat"
    let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    let userName: String
    let advertiser: MCNearbyServiceAdvertiser
    let browser: MCNearbyServiceBrowser
    
    var online: Bool
    var delegate: CommunicatorDelegate?
    
    var peersDictionary = [String: Peer]()
    var foundPeers = [MCPeerID]()
    
    func prepareSessionWith(peerID: MCPeerID) -> MCSession {
        var session: MCSession
        if peersDictionary[peerID.displayName] == nil {
            session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
            session.delegate = self
            let peer = Peer()
            peer.peerID = peerID
            peer.session = session
            peer.displayName = peerID.displayName
            peersDictionary[peerID.displayName] = peer
        } else {
            session = (peersDictionary[peerID.displayName]?.session)!
        }
        
        return session
    }
    
    override init() {
        
        userName = "vbb"
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["userName": userName], serviceType: userServiceType)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: userServiceType)
        online = true
        
        super.init()
        advertiser.delegate = self
        browser.delegate = self
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success : Bool,_ error: Error?) -> ())?) {
        
        let jsonMessage: [String: String] = ["eventType": "TextMessage",
                                             "messageId": generateMessageId(),
                                             "text": string]
        
        if JSONSerialization.isValidJSONObject(jsonMessage) {
            do {
                let messageData = try JSONSerialization.data(withJSONObject: jsonMessage, options: .prettyPrinted)
                let session = peersDictionary[userID]?.session
                try session?.send(messageData, toPeers: [(peersDictionary[userID]?.peerID)!], with: .reliable)
                if (completionHandler != nil) {
                    completionHandler!(true, nil)
                }
            } catch {
                print(error.localizedDescription)
                if (completionHandler != nil) {
                    completionHandler!(false, error)
                }
            }
        }
    }
    
//    func send(text : String) {
//        print("text: \(text) to \(availableSession().connectedPeers.count) peers")
//        
//        let jsonMessage: [String: String] = [
//            "eventType": "TextMessage",
//            "messageId": generateMessageId(),
//            "text": text
//        ]
//        
//        if JSONSerialization.isValidJSONObject(jsonMessage) {
//            do {
//                let rawData = try JSONSerialization.data(withJSONObject: jsonMessage, options: .prettyPrinted)
//                
//                if availableSession().connectedPeers.count > 0 {
//                    do {
//                        try self.availableSession().send(rawData, toPeers: availableSession().connectedPeers, with: .reliable)
//                    } catch let error {
//                        print("Error for sending: \(error)")
//                    }
//                }
//                
//            } catch let error {
//                print ("Error for parsing \(error)")
//            }
//        }
//    }
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Recieved invitation from: \(peerID.displayName)")
        let session = prepareSessionWith(peerID: peerID)
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        print("Error is: \(error)")
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID.displayName)")
        if let name = info?["userName"] {
            print("name \(name)")
//            if !foundPeers.contains(peerID) {
//                foundPeers.append(peerID)
//            }
            let session = prepareSessionWith(peerID: peerID)
            peersDictionary[peerID.displayName]?.userName = name
            delegate?.didFoundUser(userID: peerID.displayName, userName: name)
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
    }
}

extension MultipeerCommunicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            //TO-DO: сделать проверку на нахождение пира
            online = true
            print("peer \(peerID) state is connceted")
        case .notConnected:
            peersDictionary.removeValue(forKey: peerID.displayName)
            delegate?.didLostUser(userID: peerID.displayName)
        default:
            online = false
            print("peer \(peerID) state is not connected: \(state)")
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //let recievedData = String(data: data, encoding: String.Encoding.utf8)
        let recievedData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
        
        let fromUser = peersDictionary[peerID.displayName]?.userName
        delegate?.didReceiveMessage(text: recievedData["text"]!, fromUser: fromUser!, toUser: myPeerID.displayName)
        print("didRecieveData \(recievedData["text"]!)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print(#function)
    }
    
}
