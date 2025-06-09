//
//  SleepSessionViewModel.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//


import Foundation
import SwiftData

class SleepAdjustmentViewModel: ObservableObject {
    private let service: SleepSessionService
    
    @Published var showEfficiencySheet = false
    @Published var efficiencyLastWeek: Double = 0
    @Published var eligibleForBonus = false

    @Published var averageEfficiency: Double = 0
    @Published var showAdjustmentOptions: Bool = false

//    init(service: SleepSessionService) {
//        self.service = service
//    }
    
    init(context: ModelContext) {
            self.service = SleepSessionService(context: context)
        }

    func add15Minutes(to target: TimeTarget) {
        switch target {
        case .bed:
            UserDefaultsService.shared.adjustBedTime(by: 15)
        case .wake:
            UserDefaultsService.shared.adjustWakeTime(by: 15)
        case .keep:
            break
        }
        showAdjustmentOptions = false
    }
    
    func evaluateEfficiencyAndTriggerUI() {
        let avg = service.getCurrentWeekAverageEfficiency()
        averageEfficiency = avg

        if avg > 90 && UserDefaultsService.shared.shouldShowEfficiencyPrompt() {
            showAdjustmentOptions = true
            UserDefaultsService.shared.setLastPromptDate(Date())
        } else {
            showAdjustmentOptions = false
        }
    }
    
    func checkIfShouldShowWeeklySummary() {
        // Only run once at start of week
        guard UserDefaultsService.shared.shouldShowEfficiencyPrompt() else { return }

        let sessions = service.getLastWeekSessions()
        guard !sessions.isEmpty else { return }

        let total = sessions.reduce(0.0) { $0 + $1.sleepEfficiency }
        let average = total / Double(sessions.count)

        efficiencyLastWeek = average
        eligibleForBonus = average >= 90

        showEfficiencySheet = true
        UserDefaultsService.shared.setLastPromptDate(Date()) // lock for the week
    }
}

enum TimeTarget {
    case bed, wake, keep
}
