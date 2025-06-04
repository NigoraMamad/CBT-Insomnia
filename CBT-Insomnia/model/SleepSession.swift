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
    var bedTime: Date
    var wakeUpTime: Date
    var timeInBed: TimeInterval
    var sleepDuration: TimeInterval
    var sleepEfficiency: Double
    
    @Relationship var challenge: SleepChallenge?

    init(
        id: UUID = UUID(),
        bedTime: Date,
        wakeUpTime: Date,
        sleepDuration: TimeInterval,
        challenge: SleepChallenge? = nil
    ) {
        let timeInBed = wakeUpTime.timeIntervalSince(bedTime)
        let efficiency = timeInBed > 0 ? (sleepDuration / timeInBed) * 100 : 0

        self.id = id
        self.bedTime = bedTime
        self.wakeUpTime = wakeUpTime
        self.timeInBed = timeInBed
        self.sleepDuration = sleepDuration
        self.sleepEfficiency = efficiency
        self.challenge = challenge
    }
}
