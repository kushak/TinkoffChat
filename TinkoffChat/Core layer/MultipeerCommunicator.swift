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

protocol Communicator {
    
    var online: Bool {get set}
    
    weak var delegate: CommunicatorDelegate? {get set}
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}

class MultipeerCommunicator: NSObject, Communicator {
    
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
        
        userName = UIDevice.current.name
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
            let session = prepareSessionWith(peerID: peerID)
            peersDictionary[peerID.displayName]?.userName = name
            delegate?.didFoundUser(userID: peerID.displayName, userName: name)
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
        delegate?.didLostUser(userID: peerID.displayName)
    }
}

extension MultipeerCommunicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            online = true
            print("peer \(peerID) state is connceted")
        case .notConnected:
            online = false
//            peersDictionary.removeValue(forKey: peerID.displayName)
        default:
            
            print("peer \(peerID) state is not connected: \(state)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let recievedData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
//        let fromUser = peersDictionary[peerID.displayName]?.userName
//        delegate?.didReceiveMessage(text: recievedData["text"]!, fromUser: fromUser!, toUser: myPeerID.displayName)
        if let text = recievedData["text"] {
            delegate?.didReceiveMessage(text: text, fromUser: peerID.displayName, toUser: myPeerID.displayName)
            print("didRecieveData \(text)")
        }
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
