//
//  Chalenge.swift
//  TinkoffChat
//
//  Created by user on 05.04.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class Chalenge: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    
    var peerId: MCPeerID
    var session: MCSession
    var browser: MCNearbyServiceBrowser
    var advertiser: MCNearbyServiceAdvertiser
    
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession)->Void)!
    
    var dic: Dictionary<String, String>?
    
    override init() {
        peerId = MCPeerID(displayName: "Oleg12345")
        advertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: ["userName": "o.g.shipulin"], serviceType: "tikoff-chat")
        session = MCSession(peer: peerId)
        browser = MCNearbyServiceBrowser(peer: peerId, serviceType: "tinkoff-chat")
        
        super.init()
        
        browser.delegate = self
        session.delegate = self
        advertiser.delegate = self
        
        
        
    }
    
    public func start () {
        print(browser)
//        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    

    
    let serviceType = "tikoff-chat"
    let discoveryInfo = ["userName": "o.g.shipulin"]
    
    
    func generatedMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }

    //MARK: MCSessionDelegate
    
    // Remote peer changed state.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    // Received data from remote peer.
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    // Received a byte stream from remote peer.
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
        
    }
    
    // Received a byte stream from remote peer.
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    // Start receiving a resource from remote peer.
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    //MARK: MCNearbyServiceBrowserDelegate
    
    // A nearby peer has stopped advertising.
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    // Browsing did not start due to an error.
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
    }
    
    // Found a nearby advertising peer.
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        self.browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30.0)
    }
    
    
    //MARK: MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        
    }
    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.dic = ["eventType": "TextMessage",
               "messageId": generatedMessageId(),
               "text": "привет"]
        invitationHandler(true, self.session)
        do {
            try session.send(String(describing: dic).data(using: .ascii)!, toPeers: [peerID], with: .unreliable)
            print("послал")
        } catch {
            
        }
    }
    
    deinit {
        print("123")
    }
}
