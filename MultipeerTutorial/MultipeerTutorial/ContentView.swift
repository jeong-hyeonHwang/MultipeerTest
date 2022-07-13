//
//  ContentView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/13.
//

import SwiftUI
import CoreData

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height
struct ContentView: View {

    @StateObject var colorSession = ColorMultipeerSession()
    @StateObject var emojiSession = EmojiMultipeerSession()
    @State var pressedColor: String? = nil
    @State var pressedEmoji: String? = nil
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Text("PressedColor Is \(pressedColor ?? "NIL")")
                    .frame(width: width, height: height * 0.15, alignment: .center)
                Text("PressedEmoji Is \(emojiIs(s:pressedEmoji ?? "NIL"))")
                Text("SENT EMOJI IS \(emojiIs(s: emojiSession.currentEmoji?.rawValue ?? "NIL"))")
                    .frame(width: width, height: height * 0.15, alignment: .center)
                    .font(.system(size: 30))
                Text("Connected Devices:")
                    .frame(width: width, height: height * 0.1, alignment: .center)
                Text(String(describing: colorSession.connectedPeers.map(\.displayName)))
                
            }.frame(width: width, height: height * 0.8, alignment: .center)
            Divider()
            HStack {
                ForEach(NamedEmoji.allCases, id: \.self) { emoji in
                    Button(emoji.rawValue) {
                        emojiSession.send(emoji: emoji)
                        pressedEmoji = "\(emoji)"
                    }
                }
            }
            HStack {
                ForEach(NamedColor.allCases, id: \.self) { color in
                    Button(color.rawValue) {
                        colorSession.send(color: color)
                        pressedColor = "\(color)"
                    }
                    .padding()
                }
            }.frame(width: width, height: height * 0.2, alignment: .center)
            //Spacer()
        }
        .padding()
        .background(colorSession.currentColor.map(\.color) ?? .clear).ignoresSafeArea()
    }
}

extension NamedColor {
    var color: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .yellow:
            return .yellow
        }
    }
}

extension NamedEmoji {
    var emoji: String {
        switch self {
        case .Marvelous:
            return "👏"
        case .Surprising:
            return "😮"
        case .Congrats:
            return "🎉"
        case .LEGO:
            return "🔥"
        case .Idk:
            return "🤔"
        case .Good:
            return "👍"
        }
    }
}

func emojiIs(s: String) -> String {
    switch s {
    case "Marvelous":
        return "👏"
    case "Surprising":
        return "😮"
    case "Congrats":
        return "🎉"
    case "LEGO":
        return "🔥"
    case "Idk":
        return "🤔"
    case "Good":
        return "👍"
    default:
        return"😎"
    }
}
