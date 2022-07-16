//
//  PresentorView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI

struct PresenterView: View {
    @ObservedObject var presenterSession: SessionOpener
    @State var pressedEmoji: String? = nil
    
    @State var brToggleOn: Bool = false
    
    var body: some View {
        VStack() {
            VStack(spacing: 0) {
                Toggle("Browse On", isOn: $brToggleOn)
                    .padding(20)
                    .onChange(of: brToggleOn) { status in
                        if(status == true) {
                            print("BROWSING START!")
                            presenterSession.startBrowsing()
                        } else {
                            print("BROWSING STOP!")
                            presenterSession.stopBrowsing()
                            presenterSession.sessionDisconnect()
                        }
                    }
                Text("SentEmoji")
                    .padding(10)
                Text("\(emojiIs(s: presenterSession.currentEmoji?.rawValue ?? "NIL"))")
                    .font(.system(size: 60))
                    .padding(10)
            }
            .navigationTitle("Presenter")
            .navigationBarTitleDisplayMode(.inline)
            .frame(height: height * 0.3, alignment: .top)
            
            Text("Connected Devices:")
            
            List(presenterSession.connectedPeers, id: \.self) { peer in
                Text(peer.displayName)
            }
            .listStyle(.plain)
        }
        .padding()
        .onDisappear() {
            presenterSession.stopBrowsing()
        }
    }
}
