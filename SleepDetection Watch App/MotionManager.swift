//
//  MotionManager.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//

import Foundation
import CoreMotion
import WatchConnectivity

class MotionManager: NSObject, ObservableObject, WCSessionDelegate {
    private let motionManager = CMMotionManager()
    private let pedometer = CMPedometer()
    private let session = WCSession.default

    @Published var isTracking = false
    private var stepCount = 0

    override init() {
        super.init()

        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable, CMPedometer.isStepCountingAvailable() else {
            print("❌ Motion or step count not available")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.5
        isTracking = true
        stepCount = 0

        print("✅ Motion + step tracking started")

        // Start motion updates
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }

            let gravity = motion.gravity
            let still = abs(motion.userAcceleration.x) < 0.02 &&
                        abs(motion.userAcceleration.y) < 0.02 &&
                        abs(motion.userAcceleration.z) < 0.02
            let isFlat = abs(gravity.z) > 0.9

            self.sendMessage(isStill: still, isFlat: isFlat, stepCount: self.stepCount)
        }

        // ✅ Start live step count updates
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.stepCount = data.numberOfSteps.intValue
            }
        }
    }

    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
        pedometer.stopUpdates()
        isTracking = false
        print("🛑 Stopped monitoring")

        if session.isReachable {
            session.sendMessage(["isTracking": false], replyHandler: nil, errorHandler: nil)
        }
    }

    private func sendMessage(isStill: Bool, isFlat: Bool, stepCount: Int) {
        let message: [String: Any] = [
            "isStill": isStill,
            "isFlat": isFlat,
            "isTracking": true,
            "stepCount": stepCount
        ]

        if session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("❌ Send error: \(error.localizedDescription)")
            })
            print("📤 Sent → steps: \(stepCount), flat: \(isFlat), still: \(isStill)")
        } else {
            print("⚠️ iPhone not reachable")
        }
    }

    // WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ WCSession error: \(error.localizedDescription)")
        } else {
            print("✅ WCSession active")
        }
    }
}
