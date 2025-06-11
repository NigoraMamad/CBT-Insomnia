//
//  StepCounter.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 27/05/25.
//
import SwiftUI
import CoreMotion

class StepCounter: ObservableObject {
    private var pedometer = CMPedometer()
    private var startDate: Date?

    @Published var stepCount: Int = 0
    @Published var isTracking = false
    @Published var isStoppedTracking = false
    @Published var showGoalReachedAlert = false

    func startTracking() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting not available")
            return
        }
        
        stepCount = 0
        isTracking = true
        isStoppedTracking = false // Reset this flag
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
        
        // Note: Sleep session completion is now handled in StepsView
        print("StepCounter: Tracking stopped, 10 steps reached")
    }

    func reset() {
        pedometer.stopUpdates()
        stepCount = 0
        isTracking = false
        isStoppedTracking = false
        showGoalReachedAlert = false
        print("StepCounter: Reset called")
    }
}
