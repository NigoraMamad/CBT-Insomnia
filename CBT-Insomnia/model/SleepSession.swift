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
    var wakeUpTime: Date
    var timeInBed: TimeInterval
    var sleepDuration: TimeInterval
    var sleepEfficiency: Double

    @Relationship var schedule: SleepSchedule?

    init(
        id: UUID = UUID(),
        bedTime: Date,
        wakeUpTime: Date,
        sleepDuration: TimeInterval,
        schedule: SleepSchedule? = nil
    ) {
        let timeInBed = wakeUpTime.timeIntervalSince(bedTime)
        let efficiency = timeInBed > 0 ? (sleepDuration / timeInBed) * 100 : 0

        self.id = id
        self.wakeUpTime = wakeUpTime
        self.timeInBed = timeInBed
        self.sleepDuration = sleepDuration
        self.sleepEfficiency = efficiency
        self.schedule = schedule
    }
}
