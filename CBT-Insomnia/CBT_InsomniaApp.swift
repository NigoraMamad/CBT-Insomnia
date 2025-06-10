//
//  CBT_InsomniaApp.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import SwiftUI
import SwiftData

@main
struct CBT_InsomniaApp: App {
    @AppStorage("onboardingCompleted") var onboardingCompleted = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if onboardingCompleted {
                    ContentViewWrapper()
                        .preferredColorScheme(.dark)
                        .environmentObject(SleepDataService.shared)
//                        .onAppear {
//                            NotificationManager.shared.requestAuthorization()
//                        }
                    
                } else {
                    OnboardingPage1()
                }
            }
            .modelContainer(for: SleepSession.self)
        }
//        .modelContainer(for: SleepSession.self)
    }
}
