//
//  SleepDetectionApp.swift
//  SleepDetection Watch App
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//

import SwiftUI

@main
struct SleepDetection_Watch_AppApp: App {
    
    init() {
            _ = WatchSessionManager() // Keep this in memory or inject as an `@StateObject`
        }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
