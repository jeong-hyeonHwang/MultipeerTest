//
//  Audience.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/18.
//

import Foundation

import MultipeerConnectivity
import os
import SwiftUI

//https://developer.apple.com/documentation/multipeerconnectivity
//https://www.ralfebert.com/ios-app-development/multipeer-connectivity/
// 발표자 탐지
class PresenterDetector: NSObject, ObservableObject {
    
    var temp: MCPeerID?
    // 전송하고자하는 정보?
    private let serviceType = "example-emoji"
    // 나의 기기 이름
    private let myPeerId = MCPeerID(displayName: "\(UIDevice.current.name)AUD")
    // 서비스 발신
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    // 서비스 탐색
    private let serviceBrowser: MCNearbyServiceBrowser
    // 연결된 모든 디바이스 탐색을 위한 세션
    private let session: MCSession
    
    // 로그 출력
    private let log = Logger()
    
    // Save Connected Peers
    @Published var connectedPeers: [MCPeerID] = []
    
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceBrowser.delegate = self
        serviceAdvertiser.delegate = self
    }
    
    deinit {
        // Peer Browsing Stop
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func sessionIs() -> MCSession {
        return session
    }
    
    func browserIs() -> MCNearbyServiceBrowser {
        return serviceBrowser
    }
    
    func startAdvertise() {
        // Peer Advertising Start
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertise() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        // Peer Browsing Start
        serviceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func sessionDisconnect() {
        session.disconnect()
    }
}

// Error Notice Delegate
extension PresenterDetector: MCNearbyServiceAdvertiserDelegate {
    // Advertise Not Begin
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    // Receive Invitation == true
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        
        // MARK: Accept Invitation
        if(peerID.displayName.contains("PRE")) {
            invitationHandler(true, session)
            if(!connectedPeers.contains(peerID)) {
                connectedPeers.append(peerID)
            }
        }
    }
}

extension PresenterDetector: MCNearbyServiceBrowserDelegate {
    // Browsing Not Begin
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    // Found Peer
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        //MARK: Invite Peer who We Found
        if(peerID.displayName.contains("PRE")) {
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        }
    }
    
    // Lost Peer
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
    }
}

extension PresenterDetector: MCSessionDelegate {
    
    // Inform Peer Status Change
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
    }
    
    // Inform Peer's transfer Data bytes
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8) {
            log.info("didReceive Emoji \(string)") }
    }
    
    // Can't Receive Specific Item 1
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }
    
    // Can't Receive Specific Item 2
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with Progress: Progress) {
        log.error("Receiving resources is not supported")
    }
    
    // Can't Receive Specific Item 3
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
}
