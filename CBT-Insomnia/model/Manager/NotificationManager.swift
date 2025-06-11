////
////  NotificationManager.swift
////  CBT-Insomnia
////
////  Created by Nigorakhon Mamadalieva on 05/06/25.
////
//
//import Foundation
//import UserNotifications
//
//class NotificationManager {
//    static let shared = NotificationManager()
//    private let center = UNUserNotificationCenter.current()
//
//    private init() {}
//
//    // Request permission
//    func requestAuthorization() {
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            print(" Notification permission granted: \(granted)")
//            if let error = error {
//                print("Notification error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // Schedule both bedtime and wake-up notifications
//    func schedule(for schedule: SleepSchedule) {
//        cancel(for: schedule) // clean up old ones first
//
//        let idPrefix = schedule.id.uuidString
///
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
//
//    // Helper to create and add a single daily notification
//    private func scheduleNotification(id: String, title: String, body: String, time: DateComponents) {
//        var components = time
//        components.calendar = Calendar.current
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
//
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//        center.add(request)
//    }
//}
//
//
////NotificationManager.shared.schedule(for: newSchedule) -> When saving or updating a schedule:
////NotificationManager.shared.cancel(for: scheduleToDelete) -> When deleting a schedule:
// 


import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    
    private init() {}
    
    
    func scheduleDailyNotifications() {
//        center.removeAllPendingNotificationRequests()

//        scheduleNotification(for: .bedTime)
//        scheduleNotification(for: .wakeUpTime)
        
        // random notifications
        scheduleRandomNotificationAtTime(at: 15, minute: 34)
        
//        scheduleRandomNotification()
    }
    
    private func scheduleNotification(for type: NotificationType) {
        var components: DateComponents?
        var title = ""
        var body = ""
        var identifier = ""

        switch type {
        case .bedTime:
            components = UserDefaultsService.shared.getBedTimeOffset()
            title = "Bedtime Reminder"
            body = "It's time to sleep!"
            identifier = "bedtimeNotification"
        case .wakeUpTime:
            components = UserDefaultsService.shared.getWakeUpTime()
            title = "Wake Up!"
            body = "It's time to wake up"
            identifier = "wakeUpNotification"
        }
        
        guard let time = components else {
            print("⚠️ No time saved for \(type)")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error in notification's planning \(type): \(error)")
            }
        }
    }
    
    
    func scheduleRandomNotification() {
        let messages = [
            "⏰ Stay up until your bedtime — your sleep rhythm will thank you!",
            "😴 Go to bed only when you’re truly sleepy — not just bored.",
            "🛏️ Use your bed just for sleep — not scrolling!",
            "🚫 Skip the nap — save that tiredness for tonight!",
            "✨ Consistency is magic — same routine, better sleep!"
        ]
        
        guard let message = messages.randomElement() else { return }

        let randomTime = randomTimeBetween12And19()

        let content = UNMutableNotificationContent()
        content.title = "Sleep Tip 💤"
        content.body = message
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: randomTime, repeats: true)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Random notification error \(error.localizedDescription)")
            }
        }
    }
    
    func randomTimeBetween12And19() -> DateComponents {
        let hour = Int.random(in: 12...18)
        let minute = Int.random(in: 0..<60)
        return DateComponents(hour: hour, minute: minute)
    }
    
    func scheduleRandomNotificationAtTime(at hour: Int, minute: Int) {
        
        let messagesHours = [
            "⏰ Stay up until your bedtime — your sleep rhythm will thank you!",
            "😴 Go to bed only when you’re truly sleepy — not just bored.",
            "🛏️ Use your bed just for sleep — not scrolling!",
            "🚫 Skip the nap — save that tiredness for tonight!",
            "✨ Consistency is magic — same routine, better sleep!"
        ]
        
        guard let message = messagesHours.randomElement() else { return }

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let content = UNMutableNotificationContent()
        content.title = "Sleep Tip 💤"
        content.body = message
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Random notification error \(error.localizedDescription)")
            }
        }
    }
    
    func requestPermissionAndSchedule(completion: @escaping () -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.scheduleDailyNotifications()
                } else {
                    print("❌ No notification Authorization ")
                }
                completion()
            }
        }
    }
    
    
    
}




enum NotificationType {
    case bedTime
    case wakeUpTime
}

