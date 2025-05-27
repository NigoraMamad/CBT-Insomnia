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
    @Published var stepCount: Int = 0

    func startTracking() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting not available")
            return
        }

        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.stepCount = data.numberOfSteps.intValue
            }
        }
    }

    func stopTracking() {
        pedometer.stopUpdates()
    }
}

