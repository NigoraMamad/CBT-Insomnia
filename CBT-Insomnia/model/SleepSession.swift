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
    var nightDate: Date
    var badgeInTime: Date
    var badgeOutTime: Date?
    var timeInBed: TimeInterval
    var sleepDuration: TimeInterval
    
    // Computed properties
    var sleepEfficiency: Double {
        guard timeInBed > 0 && sleepDuration > 0 else { return 0 }
        return (sleepDuration / timeInBed) * 100
    }
    
    var totalNightDuration: TimeInterval {
        guard let badgeOutTime = badgeOutTime else { return 0 }
        return badgeOutTime.timeIntervalSince(badgeInTime)
    }
    
    var isComplete: Bool {
        return badgeOutTime != nil
    }
    
    // For display purposes
    var formattedNightDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: nightDate)
    }
    
    var formattedBadgeInTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: badgeInTime)
    }
    
    var formattedBadgeOutTime: String {
        guard let badgeOutTime = badgeOutTime else { return "--:--" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: badgeOutTime)
    }

    init(
        id: UUID = UUID(),
        nightDate: Date,
        badgeInTime: Date,
        badgeOutTime: Date? = nil,  // Make optional with default nil
        sleepDuration: TimeInterval = 0
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
    }
    
    // Convenience method to update sleep duration from HealthKit data
    func updateSleepDuration(_ duration: TimeInterval) {
        self.sleepDuration = duration
    }
}
