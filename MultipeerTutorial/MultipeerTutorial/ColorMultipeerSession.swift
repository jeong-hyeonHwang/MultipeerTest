//
//  ColorMultipeerSession.swift
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

class ColorMultipeerSession: NSObject, ObservableObject {
    // 전송하고자하는 정보?
    private let serviceType = "example-color"
    // 나의 기기 이름
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
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
    
    // 클래스 Initializer
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        
        // Peer Advertising Start
        serviceAdvertiser.startAdvertisingPeer()
        // Peer Browsing Start
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        // Peer Advertising Stop
        serviceAdvertiser.stopAdvertisingPeer()
        // Peer Browsing Stop
        serviceBrowser.stopBrowsingForPeers()
        
    }
}

// Error Notice Delegate
extension ColorMultipeerSession: MCNearbyServiceAdvertiserDelegate {
    // Advertise Not Begin
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }
    
    // Receive Invitation == true
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        
        // MARK: Accept Invitation
        // !CAUTION! Automatically
        invitationHandler(true, session)
    }
}

extension ColorMultipeerSession: MCNearbyServiceBrowserDelegate {
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

extension ColorMultipeerSession: MCSessionDelegate {
    
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
        log.info("didReceive bytes \(data.count) bytes")
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
