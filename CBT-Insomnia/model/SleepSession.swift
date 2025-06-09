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
        self.day = day
        self.badgeWakeUpTime = badgeWakeUpTime
        self.badgeBedTime = badgeBedTime
        self.sleepDuration = sleepDuration
        self.sleepEfficiency = badgeBedTime > 0 ? (sleepDuration / badgeBedTime) * 100 : 0
    }
}

