//
//  SleepSession.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import SwiftData
import Foundation

@Model
class SleepSession {
    var id: UUID
    var day: Date // date for every night
    var badgeWakeUpTime: Date // time from badge-out
    var badgeBedTime: TimeInterval // time from badge-in
    var sleepDuration: TimeInterval
    var sleepEfficiency: Double

//    @Relationship var schedule: SleepSchedule?

    init(
        id: UUID = UUID(),
        day: Date,
        //bedTime: Date,
        badgeWakeUpTime: Date,
        badgeBedTime: TimeInterval,
        sleepDuration: TimeInterval
//        schedule: SleepSchedule? = nil
    ) {
//        let timeInBed = wakeUpTime.timeIntervalSince(bedTime)
        let efficiency = badgeBedTime > 0 ? (sleepDuration / badgeBedTime) * 100 : 0

        self.id = id
        self.day = day
        self.badgeWakeUpTime = badgeWakeUpTime
        self.badgeBedTime = badgeBedTime
        self.sleepDuration = sleepDuration
        self.sleepEfficiency = efficiency
//        self.schedule = schedule
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



//@Query(filter: #Predicate<SleepSession> { session in
//    let calendar = Calendar.current
//    let now = Date()
//    let weekday = calendar.component(.weekday, from: now)
//    let daysSinceTuesday = (weekday >= 3) ? weekday - 3 : 7 - (3 - weekday)
//    let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
//    return session.day >= startOfWeek && session.day <= now
//})
