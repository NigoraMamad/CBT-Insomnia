//
//  SleepSessionService.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//

import Foundation
import SwiftData

@Observable
class SleepSessionService {
    let modelContext: ModelContext

    init(context: ModelContext) {
        self.modelContext = context
    }

    func getCurrentWeekSessions() -> [SleepSession] {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else { return [] }
        let today = calendar.startOfDay(for: Date())

        let predicate = #Predicate<SleepSession> {
            $0.day >= weekStart && $0.day <= today
        }

        let fetch = FetchDescriptor<SleepSession>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.day)]
        )

        return (try? modelContext.fetch(fetch)) ?? []
    }

    func getCurrentWeekAverageEfficiency() -> Double {
        let sessions = getCurrentWeekSessions()
        guard !sessions.isEmpty else { return 0 }

        let total = sessions.reduce(0.0) { $0 + $1.sleepEfficiency }
        return total / Double(sessions.count)
    }
    
    func getLastWeekSessions() -> [SleepSession] {
        let calendar = Calendar.current
        guard let thisWeek = calendar.dateInterval(of: .weekOfYear, for: Date()),
              let lastWeekStart = calendar.date(byAdding: .day, value: -7, to: thisWeek.start),
              let lastWeekEnd = calendar.date(byAdding: .day, value: -1, to: thisWeek.start)
        else { return [] }

        let predicate = #Predicate<SleepSession> {
            $0.day >= lastWeekStart && $0.day <= lastWeekEnd
        }

        let fetch = FetchDescriptor<SleepSession>(predicate: predicate, sortBy: [SortDescriptor(\.day)])
        return (try? modelContext.fetch(fetch)) ?? []
    }
}
