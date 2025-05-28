//
//  WatchReceiver 2.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//


import Foundation
import WatchConnectivity
import SwiftUI

class WatchReceiver: NSObject, WCSessionDelegate, ObservableObject {
    // Published properties for SwiftUI
    @Published var isWristFlat: Bool = false
    @Published var isWristStill: Bool = false
    @Published var isTracking: Bool = false
    @Published var stepCount: Int = 0
    @Published var hasWokenUp: Bool = false

    override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("✅ WCSession activated on iPhone")
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ WCSession activation error: \(error.localizedDescription)")
        } else {
            print("✅ WCSession activated with state: \(activationState.rawValue)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("⚠️ WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("🔄 WCSession deactivated — reactivating...")
        WCSession.default.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // Update state from Watch message
            self.isTracking = message["isTracking"] as? Bool ?? self.isTracking
            self.isWristFlat = message["isFlat"] as? Bool ?? self.isWristFlat
            self.isWristStill = message["isStill"] as? Bool ?? self.isWristStill
            self.stepCount = message["stepCount"] as? Int ?? self.stepCount

            // Trigger wake-up logic
            if self.stepCount > 10 && !self.hasWokenUp {
                self.hasWokenUp = true
                self.isTracking = false
                print("🎉 Wake-up triggered: steps = \(self.stepCount)")
            }

            print("📥 Message from Watch → steps: \(self.stepCount), flat: \(self.isWristFlat), still: \(self.isWristStill), tracking: \(self.isTracking)")
        }
    }
}
