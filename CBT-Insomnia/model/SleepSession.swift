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
      
        // Calculate initial values
        self.timeInBed = 0
        self.sleepEfficiency = 0
        
        // Update calculated properties if wake time is available
        updateCalculatedProperties()
    }
    
    // Method to update calculated properties when wake time changes
    func updateCalculatedProperties() {
        if let wake = badgeWakeUpTime {
            self.timeInBed = wake.timeIntervalSince(badgeBedTime)
            self.sleepEfficiency = timeInBed > 0 ? (sleepDuration / timeInBed) * 100 : 0
        } else {
            self.timeInBed = 0
            self.sleepEfficiency = 0
        }
    }

    var formattedNightDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: day)
    }

    var isComplete: Bool {
        return badgeWakeUpTime != nil
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
