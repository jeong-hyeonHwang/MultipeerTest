//
//  MultipeerTutorialApp.swift
//  MultipeerTutorial
//
//  Created by 황정현 on 2022/07/13.
//

import SwiftUI

@main
struct MultipeerTutorialApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
