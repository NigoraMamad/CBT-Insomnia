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
    var badgeWakeUpTime: Date
    var badgeBedTime: TimeInterval
    var sleepDuration: TimeInterval
    var sleepEfficiency: Double

    init(
        id: UUID = UUID(),
        day: Date,
        badgeWakeUpTime: Date,
        badgeBedTime: TimeInterval,
        sleepDuration: TimeInterval
    ) {
        self.id = id
        self.nightDate = nightDate
        self.badgeInTime = badgeInTime
        self.badgeOutTime = badgeOutTime
        
        // Only calculate timeInBed if badgeOutTime exists
        if let badgeOutTime = badgeOutTime {
            self.timeInBed = badgeOutTime.timeIntervalSince(badgeInTime)
        } else {
            self.timeInBed = 0
        }
        
        self.sleepDuration = sleepDuration
        self.sleepEfficiency = badgeBedTime > 0 ? (sleepDuration / badgeBedTime) * 100 : 0
    }
    
    static func currentWeek() -> Predicate<SleepSession> {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7 // MODIFY LATER TO 5
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        return #Predicate<SleepSession> { session in
            session.day >= startOfWeek && session.day <= now
        } // -> return
    } // -> currentWeek
    
    static func previousWeek() -> Predicate<SleepSession> {
        let calendar = Calendar.current
        let now = Date()

        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7

        let startOfCurrentWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        let startOfPreviousWeek = calendar.date(byAdding: .day, value: -7, to: startOfCurrentWeek)!
        let endOfPreviousWeek = calendar.date(byAdding: .second, value: -1, to: startOfCurrentWeek)! // just before current week starts

        return #Predicate<SleepSession> { session in
            session.day >= startOfPreviousWeek && session.day <= endOfPreviousWeek
        } // -> return
    } // -> previousWeek
    
}
