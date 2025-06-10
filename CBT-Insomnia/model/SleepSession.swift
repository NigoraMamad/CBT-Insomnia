//
//  SleepSession.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import Foundation
import SwiftData

@Model
class SleepSession {
    var id: UUID
    var day: Date
    var badgeWakeUpTime: Date?
    var badgeBedTime: Date
    var sleepDuration: TimeInterval
    var sleepEfficiency: Double
    var timeInBed: TimeInterval

    init(
        id: UUID = UUID(),
        day: Date,
        badgeWakeUpTime: Date? = nil,
        badgeBedTime: Date,
        sleepDuration: TimeInterval
    ) {
        self.id = id
        self.day = day
        self.badgeBedTime = badgeBedTime
        self.badgeWakeUpTime = badgeWakeUpTime
        self.sleepDuration = sleepDuration

        let calculatedTimeInBed: TimeInterval
            let calculatedEfficiency: Double

            if let wake = badgeWakeUpTime {
                calculatedTimeInBed = wake.timeIntervalSince(badgeBedTime)
                calculatedEfficiency = calculatedTimeInBed > 0 ? (sleepDuration / calculatedTimeInBed) * 100 : 0
            } else {
                calculatedTimeInBed = 0
                calculatedEfficiency = 0
            }
        
        self.timeInBed = calculatedTimeInBed
        self.sleepEfficiency = calculatedTimeInBed > 0 ? (sleepDuration / calculatedTimeInBed) * 100 : 0
    }

    static func currentWeek() -> Predicate<SleepSession> {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7 // MODIFY LATER TO 5
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        return #Predicate<SleepSession> { session in
            session.day >= startOfWeek && session.day <= now
        }
    }

    static func previousWeek() -> Predicate<SleepSession> {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7
        let startOfCurrentWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        let startOfPreviousWeek = calendar.date(byAdding: .day, value: -7, to: startOfCurrentWeek)!
        let endOfPreviousWeek = calendar.date(byAdding: .second, value: -1, to: startOfCurrentWeek)!
        return #Predicate<SleepSession> { session in
            session.day >= startOfPreviousWeek && session.day <= endOfPreviousWeek
        }
    }

    var formattedNightDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: day)
    }

    var isComplete: Bool {
        return badgeWakeUpTime != nil // Changed from 'return true'
    }

    var formattedBadgeInTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: badgeBedTime)
    }

    var formattedBadgeOutTime: String {
        guard let wakeTime = badgeWakeUpTime else { return "--:--" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: wakeTime)
    }

}

