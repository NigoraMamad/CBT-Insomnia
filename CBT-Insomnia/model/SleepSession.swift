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

    var bedTime: Date
    var wakeUpTime: Date

    var rem: TimeInterval
    var core: TimeInterval
    var deep: TimeInterval

    var timeInBed: TimeInterval
    var sleepDuration: TimeInterval
    var sleepEfficiency: Double


    init(
        id: UUID = UUID(),
        bedTime: Date,
        wakeUpTime: Date,
        rem: TimeInterval,
        core: TimeInterval,
        deep: TimeInterval
    ) {
        let timeInBed = wakeUpTime.timeIntervalSince(bedTime)
        let sleepDuration = rem + core + deep
        let efficiency = timeInBed > 0 ? (sleepDuration / timeInBed) * 100 : 0

        self.id = id
        self.bedTime = bedTime
        self.wakeUpTime = wakeUpTime
        self.rem = rem
        self.core = core
        self.deep = deep
        self.timeInBed = timeInBed
        self.sleepDuration = sleepDuration
        self.sleepEfficiency = efficiency
    }
}
