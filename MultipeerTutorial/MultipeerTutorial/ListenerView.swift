//
//  ListenerView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct ListenerView: View {
    @State var connectedPeerID: MCPeerID
    @StateObject var  listenerSession = SessionListener()
    @State var pressedEmoji: String? = nil
    
    //@State var adToggleOn: Bool = false
    @State var brToggleOn: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
//                Toggle("Advertise On", isOn: $adToggleOn)
//                    .onChange(of: adToggleOn) { status in
//                        if(status == true) {
//                            print("ADVERTISE START!")
//                            listenerSession.startAdvertise()
//                        } else {
//                            print("ADVERTISE STOP!")
//                            listenerSession.stopAdvertise()
//                            listenerSession.sessionDisconnect()
//                        }
//                    }
                Text("PressedEmoji Is \(emojiIs(s:pressedEmoji ?? "NIL"))")
//                Text("SENT EMOJI IS \(emojiIs(s: listenerSession.currentEmoji?.rawValue ?? "NIL"))")
//                    .frame(width: width, height: height * 0.15, alignment: .center)
//                    .font(.system(size: 30))
//                Text("Connected Devices:")
//                    .frame(width: width, height: height * 0.1, alignment: .center)
//                Text(String(describing: listenerSession.connectedPeers.map(\.displayName)))
            }.frame(width: width, height: height * 0.8, alignment: .center)
            Divider()
            HStack {
                ForEach(NamedEmoji.allCases, id: \.self) { emoji in
                    Button(emoji.rawValue) {
                        listenerSession.send(emoji: emoji)
                        pressedEmoji = "\(emoji)"
//                        if(adToggleOn == true) {
//                            emojiSession.send(emoji: emoji)
//                            pressedEmoji = "\(emoji)"
//                        }
                    }
                }
            }
        }
        .padding()
        .onAppear() {
            print("\(Date())")
            listenerSession.temp = connectedPeerID
            listenerSession.startAdvertise()
            print("BEFORE\(connectedPeerID.displayName)")
            print("THE CLASS\(listenerSession.temp?.displayName)")
        }
        .onDisappear() {
            listenerSession.stopAdvertise()
            listenerSession.sessionDisconnect()
        }
    }
}
