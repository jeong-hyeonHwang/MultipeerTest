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
    @State var brToggleOn: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("PressedEmoji Is \(emojiIs(s:pressedEmoji ?? "NIL"))")
            }
            .frame(width: width, height: height * 0.8, alignment: .center)
            Divider()
            HStack {
                ForEach(NamedEmoji.allCases, id: \.self) { emoji in
                    Button(emoji.rawValue) {
                        listenerSession.send(emoji: emoji)
                        pressedEmoji = "\(emoji)"
                    }
                }
            }
        }
        .padding()
        .onAppear() {
            listenerSession.temp = connectedPeerID
            listenerSession.startAdvertise()
        }
        .onDisappear() {
            listenerSession.stopAdvertise()
            listenerSession.sessionDisconnect()
        }
    }
}
