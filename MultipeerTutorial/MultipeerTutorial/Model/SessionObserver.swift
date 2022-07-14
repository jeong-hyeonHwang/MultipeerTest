//
//  EmojiMultipeerSession.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/13.
//

/// MCPeerID: uniquely identify the device (디바이스 각각을 구분하기 위한 값)
/// -> displayName will be visible to other Devices
/// MCNearbyServiceAdvertiser: advertises the service
/// MCNearbyServiceBrowser: looks for the service on the network
/// MCSession: manages all connected devices (peers) & allows sending and receiving messages

import MultipeerConnectivity
import os
import SwiftUI

class SessionObserver: NSObject, ObservableObject {
    // 전송하고자하는 정보?
    private let serviceType = "example-color"
    // 나의 기기 이름
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    // 서비스 발신
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    // 연결된 모든 디바이스 탐색을 위한 세션
    private let session: MCSession
    
    // 로그 출력
    private let log = Logger()
    
    @Published var connectRequestedPeers: [MCPeerID] = []
    
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        
        // Peer Advertising Start
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    deinit {
        // Peer Advertising Stop
        serviceAdvertiser.stopAdvertisingPeer()
        sessionDisconnect()
    }
    
    func startAdvertise() {
        // Peer Advertising Start
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAdvertise() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func sessionDisconnect() {
        session.disconnect()
    }
}

// Error Notice Delegate
extension SessionObserver: MCNearbyServiceAdvertiserDelegate {
    // Advertise Not Begin
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    // Receive Invitation == true
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        if(peerID.displayName != self.myPeerId.displayName) {
            connectRequestedPeers.append(peerID)
        }
    }
}

extension SessionObserver: MCSessionDelegate {
    
    // Inform Peer Status Change
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
    }
    
    // Inform Peer's transfer Data bytes
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8) {
            log.info("didReceive color \(string)")
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
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
