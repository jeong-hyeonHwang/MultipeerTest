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
    
    var body: some View {
        VStack(alignment: .center) {
            
            VStack {
                Text("Connected Devices:")
                    .frame(width: width, height: height * 0.1, alignment: .center)
                Text(String(describing: colorSession.connectedPeers.map(\.displayName)))
//                    .frame(width: width, height: height * 0.7, alignment: .center)
                
            }.frame(width: width, height: height * 0.8, alignment: .center)
            Divider()
            HStack {
                ForEach(NamedColor.allCases, id: \.self) { color in
                    Button(color.rawValue) {
                        colorSession.send(color: color)
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
