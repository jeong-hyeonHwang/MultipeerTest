//
//  PresentorView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI

struct PresenterView: View {
    @StateObject var presenter = Presenter()
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
                            presenter.startBrowsing()
                            presenter.startAdvertise()
                        } else {
                            print("BROWSING STOP!")
                            presenter.stopAdvertise()
                            presenter.stopBrowsing()
                            presenter.sessionDisconnect()
                        }
                    }
                Text("RECEIVED Emoji")
                    .padding(10)
                Text("\(emojiIs(s: presenter.currentEmoji?.rawValue ?? "NIL"))")
                    .font(.system(size: 60))
                    .padding(10)
            }
            .navigationTitle("Presenter")
            .navigationBarTitleDisplayMode(.inline)
            .frame(height: height * 0.3, alignment: .top)
            
            Text("Connected Devices:")
            
            List(presenter.connectedPeers, id: \.self) { peer in
                if(!peer.displayName.contains("AUD"))
                {
                    Text(peer.displayName)
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .onDisappear() {
            presenter.stopBrowsing()
        }
    }
}
