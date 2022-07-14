//
//  PresentorView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI

struct PresentorView: View {
    @StateObject var presentorSession = SessionOpener()
    @State var pressedEmoji: String? = nil
    
    @State var brToggleOn: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Toggle("Browse On", isOn: $brToggleOn)
                    .onChange(of: brToggleOn) { status in
                        if(status == true) {
                            print("BROWSING START!")
                            presentorSession.startBrowsing()
                        } else {
                            print("BROWSING STOP!")
                            presentorSession.stopBrowsing()
                            presentorSession.sessionDisconnect()
                        }
                    }
//                Text("PressedEmoji Is \(emojiIs(s:pressedEmoji ?? "NIL"))")
                Text("SENT EMOJI IS \(emojiIs(s: presentorSession.currentEmoji?.rawValue ?? "NIL"))")
                    .frame(width: width, height: height * 0.15, alignment: .center)
                    .font(.system(size: 30))
                Text("Connected Devices:")
                    .frame(width: width, height: height * 0.1, alignment: .center)
                Text(String(describing: presentorSession.connectedPeers.map(\.displayName)))
                
            }.frame(width: width, height: height * 0.8, alignment: .center)
            Divider()
//            HStack {
//                ForEach(NamedEmoji.allCases, id: \.self) { emoji in
//                    Button(emoji.rawValue) {
//                        presentorSession.send(emoji: emoji)
//                        pressedEmoji = "\(emoji)"
////                        if(adToggleOn == true) {
////                            emojiSession.send(emoji: emoji)
////                            pressedEmoji = "\(emoji)"
////                        }
//                    }
//                }
//            }
        }
        .padding()
        .onAppear() {
            print("\(Date())")
        }
        .onDisappear() {
            presentorSession.stopBrowsing()
            presentorSession.sessionDisconnect()
        }
    }
}
