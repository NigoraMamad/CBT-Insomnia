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
    @StateObject var sleepDataService = SleepDataService()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if onboardingCompleted {
                    ContentViewWrapper()
                        .preferredColorScheme(.dark)
                        .environmentObject(SleepDataService.shared)
                        .onAppear {
                            UNUserNotificationCenter.current().getNotificationSettings { settings in
                                if settings.authorizationStatus == .authorized {
                                    NotificationManager.shared.scheduleDailyNotifications()
                                }
                            }
                        }
                } else {
                    OnboardingPage1()
                }
            }
            .modelContainer(for: SleepSession.self)
        }
//        .modelContainer(for: SleepSession.self)
    }
}
