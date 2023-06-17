//
//  StormViewerApp.swift
//  StormViewer
//
//  Created by Mateusz Brychczynski on 20/05/2023.
//

import SwiftUI

@main
struct StormViewerApp: App {
    var body: some Scene {
        Window("Storm Viewer", id: "main") {
            ContentView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .undoRedo) { }
            CommandGroup(replacing: .pasteboard) { }
        }
    }
}
