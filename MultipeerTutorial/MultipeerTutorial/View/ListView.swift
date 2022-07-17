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
                    NavigationLink(destination: AudienceView(connectedPeerID: peerID)) {
                        HStack {
                            Text(peerID.displayName)
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationTitle("Device List")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear() {
            sessionObserver.sessionDisconnect()
            sessionObserver.stopAdvertise()
            sessionObserver.connectRequestedPeers.removeAll()
        }
        .onAppear() {
            sessionObserver.startAdvertise()
        }
    }
}
