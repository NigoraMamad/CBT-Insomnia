//
//  CBT_InsomniaApp.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import SwiftUI

@main
struct CBT_InsomniaApp: App {
    @State var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            StaticsView()
                .environmentObject(manager)
        }
    }
}
