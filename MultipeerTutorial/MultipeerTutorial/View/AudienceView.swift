//
//  ListenerView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct AudienceView: View {
    @State var connectedPeerID: MCPeerID
    @StateObject var audience = SessionAudience()
    
    @State var pressedEmoji: String? = nil
    @State var brToggleOn: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("SEND Emoji")
                    .padding(15)
                Text("\(emojiIs(s:pressedEmoji ?? "NIL"))")
                    .font(.system(size: 60))
            }
            .frame(width: width, height: height * 0.4, alignment: .center)
            VStack(spacing: 25){
                ForEach(NamedEmoji.allCases, id: \.self) { emoji in
                    Button(emoji.rawValue) {
                        audience.send(emoji: emoji)
                        pressedEmoji = "\(emoji)"
                    }
                }
            }.frame(width: width, height: height * 0.6, alignment: .center)
        }
        .navigationTitle("\(connectedPeerID.displayName)")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear() {
            audience.temp = connectedPeerID
            audience.startAdvertise()
        }
        .onDisappear() {
            audience.stopAdvertise()
            audience.sessionDisconnect()
        }
    }
}
