//
//  PresentorView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI

struct PresenterView: View {
    
    // MARK: Presenter Initialize
    @StateObject var presenter = SessionPresenter()
    
    // MARK: Audience로부터 받은 이모지
    @State var receivedEmoji: String? = nil
    
    @State var brToggleOn: Bool = false
    
    var body: some View {
        VStack() {
            VStack(spacing: 0) {
                Toggle("Browse On", isOn: $brToggleOn)
                    .padding(20)
                    .onChange(of: brToggleOn) { status in
                        if(status == true) {
                            // Presenter Brosing, Advertising Start
                            print("BROWSING START!")
                            presenter.startBrowsing()
                            presenter.startAdvertise()
                        } else {
                            // Presenter Brosing, Advertising Stop
                            // Session Disconnect
                            print("BROWSING STOP!")
                            presenter.stopAdvertise()
                            presenter.stopBrowsing()
                            presenter.sessionDisconnect()
                        }
                    }
                Text("RECEIVED Emoji")
                    .padding(10)
                // MARK: 수신한 이모지 출력
                Text("\(emojiIs(s: presenter.receivedEmoji?.rawValue ?? "NIL"))")
                    .font(.system(size: 60))
                    .padding(10)
            }
            .navigationTitle("Presenter")
            .navigationBarTitleDisplayMode(.inline)
            .frame(height: height * 0.3, alignment: .top)
            
            Text("Connected Devices:")
            
            List(presenter.connectedPeers, id: \.self) { peer in
                if(!peer.displayName.contains(audienceSuffix) && !peer.displayName.contains(presenterSuffix))
                {
                    Text(peer.displayName)
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .onDisappear() {
            presenter.stopAdvertise()
            presenter.stopBrowsing()
            presenter.sessionDisconnect()
        }
    }
}
