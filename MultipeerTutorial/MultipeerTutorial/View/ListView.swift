//
//  ListView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/14.
//

import Foundation
import SwiftUI

struct ListView: View {
    // MARK: PresenterDetector Initialize
    @StateObject var presenterDetector = PresenterDetector()
    
    var body: some View {
        VStack{
            HStack{
                List(presenterDetector.connectedPeers, id: \.self) { peerID in
                    if (peerID.displayName.contains(presenterSuffix)) {
                        NavigationLink(destination: AudienceView(currentPresenter: peerID)) {
                            HStack {
                                Text(peerID.displayName.substring(from: 0, to: peerID.displayName.count-4))
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Device List")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear() {
            presenterDetector.sessionDisconnect()
            presenterDetector.stopBrowsing()
        }
        .onAppear() {
            presenterDetector.startBrowsing()
            
        }
    }
}
