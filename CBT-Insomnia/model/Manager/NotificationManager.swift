//
//  NotificationManager.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 05/06/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()

    private init() {}

    // Request permission
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print(" Notification permission granted: \(granted)")
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }

    // Schedule both bedtime and wake-up notifications
//    func schedule(for schedule: SleepSchedule) {
//        cancel(for: schedule) // clean up old ones first
//
//        let idPrefix = schedule.id.uuidString
//
//        scheduleNotification(
//            id: "bed-\(idPrefix)",
//            title: "Bedtime",
//            body: "It's time to go to bed.",
//            time: schedule.bedTime
//        )
//
//        scheduleNotification(
//            id: "wake-\(idPrefix)",
//            title: "Wake Up ",
//            body: "Time to start your day!",
//            time: schedule.wakeUpTime
//        )
//    }
//
//    // Cancel both notifications for a schedule
//    func cancel(for schedule: SleepSchedule) {
//        let idPrefix = schedule.id.uuidString
//        center.removePendingNotificationRequests(withIdentifiers: ["bed-\(idPrefix)", "wake-\(idPrefix)"])
//    }

    // Helper to create and add a single daily notification
    private func scheduleNotification(id: String, title: String, body: String, time: DateComponents) {
        var components = time
        components.calendar = Calendar.current

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }
}


//NotificationManager.shared.schedule(for: newSchedule) -> When saving or updating a schedule:
//NotificationManager.shared.cancel(for: scheduleToDelete) -> When deleting a schedule:
 
