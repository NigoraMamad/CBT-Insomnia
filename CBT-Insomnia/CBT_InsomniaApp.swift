//
//  CBT_InsomniaApp.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import SwiftUI

@main
struct AlarmTestApp: App {
    @AppStorage("onboardingCompleted") var onboardingCompleted = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if onboardingCompleted {
                    ContentView()
                        .preferredColorScheme(.dark)

                } else {
                    OnboardingPage1()
                }
            }
        }
    }
}
