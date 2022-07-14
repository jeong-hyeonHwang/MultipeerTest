//
//  ContentView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/13.
//

import SwiftUI
import CoreData


struct ContentView: View {
        
        var body: some View {
            
            NavigationView {
                VStack {
                    NavigationLink(destination: PresentorView()) {
                        Text("Session Opener")
                    }
                    NavigationLink(destination: ListView()) {
                        Text("Session Listener")
                    }
                }
            }
        }
}
