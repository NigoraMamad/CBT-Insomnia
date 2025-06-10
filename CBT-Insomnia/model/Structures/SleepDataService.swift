//
//  SleepDataService.swift
//  CBT-Insomnia
//
//  Created by Michele Coppola on 08/06/25.
//

import Foundation
import SwiftData

class SleepDataService: ObservableObject {
    static let shared = SleepDataService()
    
    func startSleepSession(context: ModelContext, badgeBedTime: Date = Date()) {
        let day = getNightDateForBedTime(badgeBedTime)
        if let existingSession = getSleepSession(for: day, context: context) {
            existingSession.badgeBedTime = badgeBedTime
            // Don't modify badgeOutTime here - leave it as nil until wake up
        } else {
            let session = SleepSession(
              day: day,
              badgeBedTime: badgeBedTime, sleepDuration: 8.0 // this line must be changed
                // Don't set badgeOutTime - let it remain nil
            )
            context.insert(session)
        }
        saveContext(context)
    }
    
    func completeSleepSession(context: ModelContext, badgeWakeUpTime: Date = Date()) {
        print("Attempting to complete sleep session. Badge-out time: \(badgeWakeUpTime)") // <-- ADD THIS LINE
        let day = getNightDateForWakeTime(badgeWakeUpTime)
        print("Calculated day for wake time: \(day)") // <-- ADD THIS LINE
    
        if let session = getSleepSession(for: day, context: context) {
            print("Found session to complete: \(session.id) for day \(session.day)") // <-- ADD THIS LINE
            session.badgeWakeUpTime = badgeWakeUpTime
            session.timeInBed = badgeWakeUpTime.timeIntervalSince(session.badgeBedTime)
            print("Session badgeWakeUpTime set to: \(String(describing: session.badgeWakeUpTime))") // <-- ADD THIS LINE
            print("Session timeInBed set to: \(session.timeInBed)") // <-- ADD THIS LINE
            saveContext(context) // This already has a print for failure
            print("Sleep session completed and save attempted for \(day)")
        } else {
            print("Failed to find sleep session to complete for \(day)")
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
        if hour >= 0 && hour < 6 {
            return calendar.date(byAdding: .day, value: -1, to: bedTime) ?? bedTime
        }
        return bedTime
    }
    
    private func getNightDateForWakeTime(_ wakeTime: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: wakeTime)
        if hour >= 0 && hour < 12 {
            return calendar.date(byAdding: .day, value: -1, to: wakeTime) ?? wakeTime
        }
        return wakeTime
    }
    
    private func saveContext(_ context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
