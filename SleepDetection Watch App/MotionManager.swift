//
//  MotionManager.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//


import CoreMotion
import WatchConnectivity

class MotionManager: NSObject, ObservableObject {
    private let motionManager = CMMotionManager()
    private let session = WCSession.default

    @Published var isTracking = false

    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 0.5
        isTracking = true

        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion else { return }

            let gravity = motion.gravity
            let still = abs(motion.userAcceleration.x) < 0.02 &&
                        abs(motion.userAcceleration.y) < 0.02 &&
                        abs(motion.userAcceleration.z) < 0.02

            let isFlat = abs(gravity.z) > 0.9

            if self.session.isReachable {
                self.session.sendMessage([
                    "isStill": still,
                    "isFlat": isFlat,
                    "isTracking": true
                ], replyHandler: nil, errorHandler: nil)
            }
        }
    }

    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
        isTracking = false

        if session.isReachable {
            session.sendMessage(["isTracking": false], replyHandler: nil, errorHandler: nil)
        }
    }
}
