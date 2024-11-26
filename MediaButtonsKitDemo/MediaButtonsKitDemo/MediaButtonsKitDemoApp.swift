//
//  MediaButtonsKitDemoApp.swift
//  MediaButtonsKitDemo
//
//  Created by Bartlomiej Lanczyk on 22/10/2024.
//

import SwiftUI

@main
struct MediaButtonsKitDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Various", systemImage: "scribble")
                    }
                LiveExampleApp()
                    .tabItem {
                        Label("Live", systemImage: "apps.ipad")
                    }
            }
        }
    }
}
