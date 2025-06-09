//
//  CBT_InsomniaApp.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import SwiftUI

@main
struct CBT_InsomniaApp: App {
    @AppStorage("onboardingCompleted") var onboardingCompleted = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if onboardingCompleted {
                    ContentView()
//                        .onAppear {
//                            NotificationManager.shared.requestAuthorization()
//                        }
                    
                } else {
                    OnboardingPage1()
                }
            }
            .preferredColorScheme(.dark)
            .modelContainer(for: SleepSession.self)
        }
    }
}
