//
//  StepCounter.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 27/05/25.
//
import SwiftUI
import CoreMotion
import SwiftData

class StepCounter: ObservableObject {
    private var pedometer = CMPedometer()
    private var startDate: Date?

    @Published var stepCount: Int = 0
    @Published var isTracking = false
    @Published var isStoppedTracking = false
    @Published var showGoalReachedAlert = false
    
    @EnvironmentObject private var sleepDataService: SleepDataService
    @Environment(\.modelContext) private var modelContext

    func startTracking() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting not available")
            return
        }

        stepCount = 0
        isTracking = true
        showGoalReachedAlert = false
        startDate = Date()

        guard let fromDate = startDate else { return }

        // Start live updates from now
        pedometer.startUpdates(from: fromDate) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else { return }

            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue

                if self.stepCount >= 10 {
                    self.stopTracking()
                    self.showGoalReachedAlert = true
                }
            }
        }
    }

    func stopTracking() {
        pedometer.stopUpdates()
        isTracking = false
        isStoppedTracking = true
        
        // Save badge-out time
        SleepDataService.shared.completeSleepSession(context: modelContext)
    }

    func reset() {
        stopTracking()
        stepCount = 0
        showGoalReachedAlert = false
    }
}
