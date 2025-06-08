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
        bedTime: Date,
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
}
