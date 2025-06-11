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
    var stageDurations: [SleepStageDuration]

    init(
        id: UUID = UUID(),
        day: Date,
        badgeWakeUpTime: Date? = nil,
        badgeBedTime: Date,
        sleepDuration: TimeInterval,
        stageDurations: [SleepStageDuration] = []
    ) {
        self.id = id
        self.day = day
        self.badgeBedTime = badgeBedTime
        self.badgeWakeUpTime = badgeWakeUpTime
        self.sleepDuration = sleepDuration
        self.stageDurations = stageDurations

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

    var formattedNightDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: day)
    }

    var isComplete: Bool {
        return true // Since badgeWakeUpTime is now non-optional
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

    func duration(stage: SleepStages) -> TimeInterval {
        stageDurations.first { $0.stage == stage.rawValue }?.duration ?? 0
    } // -> duration
    
}

