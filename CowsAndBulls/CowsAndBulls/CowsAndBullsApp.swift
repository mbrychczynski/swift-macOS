//
//  CowsAndBullsApp.swift
//  CowsAndBulls
//
//  Created by Mateusz Brychczynski on 21/05/2023.
//

import SwiftUI

@main
struct CowsAndBullsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentSize)
        Settings(content: SettingsView.init)
    }
}
