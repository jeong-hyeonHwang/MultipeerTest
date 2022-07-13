//
//  ContentView.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/13.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @StateObject var colorSession = ColorMultipeerSession()
    
    var body: some View {
        Text("hi")
    }
}
