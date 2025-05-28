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
    private let session = WCSession.default
    private let pedometer = CMPedometer()
    
    @Published var isTracking = false
    private var trackingStartDate: Date?

    override init() {
        super.init()

        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable, CMPedometer.isStepCountingAvailable() else {
            print("❌ Motion or step counting not available")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.5
        trackingStartDate = Date()
        isTracking = true

        print("✅ Motion tracking & step counting started")

        // Start motion updates
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }

            let gravity = motion.gravity
            let still = abs(motion.userAcceleration.x) < 0.02 &&
                        abs(motion.userAcceleration.y) < 0.02 &&
                        abs(motion.userAcceleration.z) < 0.02
            let isFlat = abs(gravity.z) > 0.9

            // Query steps since start
            if let startDate = self.trackingStartDate {
                self.pedometer.queryPedometerData(from: startDate, to: Date()) { data, error in
                    guard let data = data, error == nil else {
                        print("❌ Step count error: \(error?.localizedDescription ?? "unknown")")
                        return
                    }

                    let steps = data.numberOfSteps.intValue

                    let message: [String: Any] = [
                        "isStill": still,
                        "isFlat": isFlat,
                        "isTracking": true,
                        "stepCount": steps
                    ]

                    if self.session.isReachable {
                        self.session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                            print("❌ Send error: \(error.localizedDescription)")
                        })
                        print("📤 Sent to iPhone: steps=\(steps), flat=\(isFlat), still=\(still)")
                    } else {
                        print("⚠️ iPhone not reachable")
                    }
                }
            }
        }
    }

    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
        pedometer.stopUpdates()
        isTracking = false

        print("🛑 Stopped tracking")

        if session.isReachable {
            session.sendMessage(["isTracking": false], replyHandler: nil, errorHandler: nil)
        }
    }

    // WCSessionDelegate required
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ WCSession activation error: \(error.localizedDescription)")
        } else {
            print("✅ WCSession activated: \(activationState.rawValue)")
        }
    }
}
