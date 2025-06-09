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
    
    func add15Minutes(to option: SleepAdjustmentOption) {
        let calendar = Calendar.current
        let offset = DateComponents(minute: 15)

        switch option {
        case .wake:
            let existing = UserDefaultsService.shared.getWakeUpOffset() ?? DateComponents(hour: 0, minute: 0)
            let base = calendar.date(from: existing) ?? Date(timeIntervalSince1970: 0)
            let new = calendar.date(byAdding: offset, to: base)!
            let newOffset = calendar.dateComponents([.hour, .minute], from: new)
            UserDefaultsService.shared.saveWakeUpOffset(newOffset)

        case .bed:
            let existing = UserDefaultsService.shared.getBedTimeOffset() ?? DateComponents(hour: 0, minute: 0)
            let base = calendar.date(from: existing) ?? Date(timeIntervalSince1970: 0)
            let negativeOffset = DateComponents(minute: -15)
            let new = calendar.date(byAdding: negativeOffset, to: base)!
            let newOffset = calendar.dateComponents([.hour, .minute], from: new)
            UserDefaultsService.shared.saveBedTimeOffset(newOffset)

        case .keep:
            break
        }

        UserDefaultsService.shared.setLastPromptDate(Date())
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
    
//    func checkIfShouldShowWeeklySummary() {
//        // Only run once at start of week
//        guard UserDefaultsService.shared.shouldShowEfficiencyPrompt() else { return }
//
//        let sessions = service.getLastWeekSessions()
//        guard !sessions.isEmpty else { return }
//
//        let total = sessions.reduce(0.0) { $0 + $1.sleepEfficiency }
//        let average = total / Double(sessions.count)
//
//        efficiencyLastWeek = average
//        eligibleForBonus = average >= 90
//
//        showEfficiencySheet = true
//        UserDefaultsService.shared.setLastPromptDate(Date()) // lock for the week
//    }
    
    
    //to test
    func checkIfShouldShowWeeklySummary() {
        #if DEBUG
        showEfficiencySheet = true
        efficiencyLastWeek = 92
        eligibleForBonus = true
        return
        #endif

        guard UserDefaultsService.shared.shouldShowEfficiencyPrompt() else { return }

        let sessions = service.getLastWeekSessions()
        guard !sessions.isEmpty else { return }

        let total = sessions.reduce(0.0) { $0 + $1.sleepEfficiency }
        let average = total / Double(sessions.count)

        efficiencyLastWeek = average
        eligibleForBonus = average >= 90
        showEfficiencySheet = true
        UserDefaultsService.shared.setLastPromptDate(Date())
    }

}

enum SleepAdjustmentOption {
    case bed, wake, keep
}
