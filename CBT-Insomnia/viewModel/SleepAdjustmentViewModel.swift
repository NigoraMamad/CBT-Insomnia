//
//  SleepSessionViewModel.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//


import Foundation

class SleepAdjustmentViewModel: ObservableObject {
    private let service: SleepSessionService

    @Published var averageEfficiency: Double = 0
    @Published var showAdjustmentOptions: Bool = false

    init(service: SleepSessionService) {
        self.service = service
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

}

enum TimeTarget {
    case bed, wake, keep
}
