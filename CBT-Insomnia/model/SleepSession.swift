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

    init(
        id: UUID = UUID(),
        day: Date,
        badgeWakeUpTime: Date? = nil,
        badgeBedTime: Date,
        sleepDuration: TimeInterval
    ) {
        self.id = id
        self.day = day
        self.badgeBedTime = badgeBedTime
        self.badgeWakeUpTime = badgeWakeUpTime
        self.sleepDuration = sleepDuration

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
            self.sleepEfficiency = timeInBed > 0 ? min((sleepDuration / timeInBed) * 100, 100) : 0
        } else {
            self.timeInBed = 0
            self.sleepEfficiency = 0
        }
    }

    static func currentWeek() -> Predicate<SleepSession> {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7 // MODIFY LATER TO 5
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        return #Predicate<SleepSession> { session in
            session.day >= startOfWeek && session.day <= now
        }
    }

    static func previousWeek() -> Predicate<SleepSession> {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7
        let startOfCurrentWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        let startOfPreviousWeek = calendar.date(byAdding: .day, value: -7, to: startOfCurrentWeek)!
        let endOfPreviousWeek = calendar.date(byAdding: .second, value: -1, to: startOfCurrentWeek)!
        return #Predicate<SleepSession> { session in
            session.day >= startOfPreviousWeek && session.day <= endOfPreviousWeek
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
}
