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
    
    @StateObject var  listMakeListener = EmojiMultipeerSession()
    var body: some View {
        VStack{
            HStack{
                List(listMakeListener.connectRequestedPeers, id: \.self) { peerID in
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
            listMakeListener.startBrowsing()
            print(listMakeListener.connectedPeers)
        }
        .onDisappear() {
            listMakeListener.sessionDisconnect()
        }
    }
}
