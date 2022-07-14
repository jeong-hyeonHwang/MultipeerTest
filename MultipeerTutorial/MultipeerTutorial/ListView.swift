//
//  ListView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct ListView: View {
    @StateObject var sessionObserver = SessionObserver()
    
    var body: some View {
        VStack{
            HStack{
                List(sessionObserver.connectRequestedPeers, id: \.self) { peerID in
                    NavigationLink(destination: ListenerView(connectedPeerID: peerID)) {
                        HStack {
                            Text(peerID.displayName)
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear() {
            sessionObserver.startBrowsing()
        }
        .onDisappear() {
            sessionObserver.sessionDisconnect()
        }
    }
}
