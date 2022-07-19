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
    
    // MARK: 현재 연결된 발표자
    @State var currentPresenter: MCPeerID
    // MARK: Audience Initialize
    @StateObject var audience = SessionAudience()
    
    // MARK: 가장 최근에 눌린 이모지
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
                        audience.send(emoji: emoji, receiver: currentPresenter)
                        pressedEmoji = "\(emoji)"
                    }
                }
            }.frame(width: width, height: height * 0.6, alignment: .center)
        }
        .navigationTitle("\(currentPresenter.displayName.substring(from: 0, to: currentPresenter.displayName.count-4))")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .onAppear() {
            audience.currentPresenter = currentPresenter
            audience.startAdvertise()
        }
        .onDisappear() {
            audience.stopAdvertise()
            audience.sessionDisconnect()
        }
    }
}
