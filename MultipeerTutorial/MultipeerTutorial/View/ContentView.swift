//
//  ContentView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/13.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(destination: PresenterView()) {
                    Text("Session Presenter")
                        .font(.system(.title2))
                }.frame(width: width, height: height * 0.5, alignment: .center)
                NavigationLink(destination: ListView()) {
                    Text("Session Listener")
                        .font(.system(.title2))
                }.frame(width: width, height: height * 0.5, alignment: .center)
            }
        }
    }
}
