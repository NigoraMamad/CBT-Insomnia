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

    @Published var isTracking = false

    override init() {
        super.init()

        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else {
            print("❌ Device motion not available")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.5
        isTracking = true

        print("✅ Motion tracking started")

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else {
                print("❌ No motion data")
                return
            }

            let gravity = motion.gravity
            let still = abs(motion.userAcceleration.x) < 0.02 &&
                        abs(motion.userAcceleration.y) < 0.02 &&
                        abs(motion.userAcceleration.z) < 0.02

            let isFlat = abs(gravity.z) > 0.9

            let message: [String: Any] = [
                "isStill": still,
                "isFlat": isFlat,
                "isTracking": true
            ]

            if self.session.isReachable {
                self.session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("❌ Failed to send: \(error.localizedDescription)")
                })
                print("📤 Sent to iPhone: isFlat=\(isFlat), isStill=\(still)")
            } else {
                print("⚠️ iPhone not reachable")
            }
        }
    }

    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
        isTracking = false

        print("🛑 Motion tracking stopped")

        if session.isReachable {
            session.sendMessage(["isTracking": false], replyHandler: nil, errorHandler: { error in
                print("❌ Failed to send stop message: \(error.localizedDescription)")
            })
        } else {
            print("⚠️ iPhone not reachable to notify stop")
        }
    }

    // Required for WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ Session activation error: \(error.localizedDescription)")
        } else {
            print("✅ WCSession activated with state: \(activationState.rawValue)")
        }
    }
}

