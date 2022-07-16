//
//  SessionOpener.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation

import MultipeerConnectivity
import os
import SwiftUI

//https://developer.apple.com/documentation/multipeerconnectivity
//https://www.ralfebert.com/ios-app-development/multipeer-connectivity/
class SessionOpener: NSObject, ObservableObject {
    // 전송하고자하는 정보?
    private let serviceType = "example-color"
    // 나의 기기 이름
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    // 서비스 탐색
    private let serviceBrowser: MCNearbyServiceBrowser
    // 연결된 모든 디바이스 탐색을 위한 세션
    private let session: MCSession
    
    // 로그 출력
    private let log = Logger()
    
    // Save Connected Peers
    @Published var connectedPeers: [MCPeerID] = []
    
    // Save Emoji Setting
    @Published var currentEmoji: NamedEmoji? = nil
    // 클래스 Initializer
    
    // Color Send
    func send(emoji: NamedEmoji) {
        log.info("sendEmoji: \(String(describing: emoji)) to \(self.session.connectedPeers.count) peers")
        //self.currentColor = color
        
        // Is there any Connected Peers more than 1
        if (!session.connectedPeers.isEmpty) {
            do {
                try session.send(emoji.rawValue.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                log.error("Error for sending: \(String(describing: error))")
            }
        }
    }
    
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceBrowser.delegate = self
    }
    
    deinit {
        // Peer Browsing Stop
        serviceBrowser.stopBrowsingForPeers()
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

extension SessionOpener: MCNearbyServiceBrowserDelegate {
    // Browsing Not Begin
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }
    
    // Found Peer
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        //MARK: Invite Peer who We Found
        // !CAUTION! Automatically
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    // Lost Peer
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
    }
}

extension SessionOpener: MCSessionDelegate {
    
    // Inform Peer Status Change
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        
        // Update Peer's Status
        // !CAUTION! Automatically
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
    }
    
    // Inform Peer's transfer Data bytes
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8), let emoji = NamedEmoji(rawValue: string) {
            log.info("didReceive color \(string)")
            DispatchQueue.main.async {
                self.currentEmoji = emoji
            }
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
    }
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        log.info("didReceive bytes \(data.count) bytes")
//    }
    
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
