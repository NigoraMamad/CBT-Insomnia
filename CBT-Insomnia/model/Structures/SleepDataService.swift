import Foundation
import SwiftData

class SleepDataService: ObservableObject {
    static let shared = SleepDataService()
    
    func startSleepSession(context: ModelContext, badgeBedTime: Date = Date()) {
        print("🛏️ Starting sleep session. Badge-in time: \(badgeBedTime)")
        let day = getNightDateForBedTime(badgeBedTime)
        print("📅 Calculated day for bed time: \(day)")
        
        if let existingSession = getSleepSession(for: day, context: context) {
            print("📝 Updating existing session")
            existingSession.badgeBedTime = badgeBedTime
            existingSession.updateCalculatedProperties()
        } else {
            print("➕ Creating new session")
            let sleepDuration = UserDefaultsService.shared.getSleepDuration()?.timeInterval ?? 8.0 * 3600 // Default 8 hours
            let session = SleepSession(
                day: day,
                badgeBedTime: badgeBedTime,
                sleepDuration: sleepDuration
            )
            context.insert(session)
        }
        saveContext(context)
        print("✅ Sleep session started and saved for \(day)")
    }
    
    func completeSleepSession(context: ModelContext, badgeWakeUpTime: Date = Date()) {
        print("⏰ Attempting to complete sleep session. Badge-out time: \(badgeWakeUpTime)")
        let day = getNightDateForWakeTime(badgeWakeUpTime)
        print("📅 Calculated day for wake time: \(day)")
    
        if let session = getSleepSession(for: day, context: context) {
            print("✅ Found session to complete: \(session.id) for day \(session.day)")
            session.badgeWakeUpTime = badgeWakeUpTime
            session.updateCalculatedProperties() // Update calculated properties
            print("⏰ Session badgeWakeUpTime set to: \(String(describing: session.badgeWakeUpTime))")
            print("🕐 Session timeInBed set to: \(session.timeInBed) seconds (\(session.timeInBed/3600) hours)")
            print("📊 Session efficiency: \(session.sleepEfficiency)%")
            saveContext(context)
            print("💾 Sleep session completed and saved for \(day)")
        } else {
            print("❌ Failed to find sleep session to complete for \(day)")
            // Let's also check what sessions exist
            let allSessions = getRecentSleepSessions(context: context, limit: 10)
            print("🔍 Available sessions: \(allSessions.map { "\($0.day): \($0.formattedBadgeInTime)" })")
        }
    }
    
    func getSleepSession(for day: Date, context: ModelContext) -> SleepSession? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: day)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = #Predicate<SleepSession> {
            $0.day >= startOfDay && $0.day < endOfDay
        }
        let descriptor = FetchDescriptor<SleepSession>(predicate: predicate)
        return try? context.fetch(descriptor).first
    }

    // Updated to accept context parameter
    func getRecentSleepSessions(context: ModelContext, limit: Int = 7) -> [SleepSession] {
        var descriptor = FetchDescriptor<SleepSession>(
            sortBy: [SortDescriptor(\.day, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }
    
    // Get only completed sleep sessions for statistics - also updated to accept context
    func getCompletedSleepSessions(context: ModelContext, limit: Int = 7) -> [SleepSession] {
        let predicate = #Predicate<SleepSession> { session in
            session.badgeWakeUpTime != nil
        }
        
        var descriptor = FetchDescriptor<SleepSession>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.day, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }
    
    private func getNightDateForBedTime(_ bedTime: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: bedTime)
        // If bedtime is between midnight and 6 AM, it belongs to the previous day's "night"
        if hour >= 0 && hour < 6 {
            return calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: bedTime)) ?? bedTime
        }
        return calendar.startOfDay(for: bedTime)
    }
    
    private func getNightDateForWakeTime(_ wakeTime: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: wakeTime)
        // If wake time is between midnight and 12 PM, it belongs to the previous day's "night"
        if hour >= 0 && hour < 12 {
            return calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: wakeTime)) ?? wakeTime
        }
        return calendar.startOfDay(for: wakeTime)
    }
    
    private func saveContext(_ context: ModelContext) {
        do {
            try context.save()
            print("💾 Context saved successfully")
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }
}
