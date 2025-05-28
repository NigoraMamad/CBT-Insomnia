//
//  WatchReceiver 2.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//


import WatchConnectivity
import SwiftUI


class WatchReceiver: NSObject, WCSessionDelegate, ObservableObject {
    @Published var isWristFlat: Bool = false
    @Published var isWristStill: Bool = false
    @Published var isTracking: Bool = false

    override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("✅ WCSession activated on iPhone")
        }
    }

    // MARK: - WCSessionDelegate methods

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ WCSession activation error: \(error.localizedDescription)")
        } else {
            print("✅ WCSession activation complete with state: \(activationState.rawValue)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("⚠️ WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("🔄 WCSession deactivated – reactivating...")
        WCSession.default.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let tracking = message["isTracking"] as? Bool {
                self.isTracking = tracking
            }

            if let flat = message["isFlat"] as? Bool {
                self.isWristFlat = flat
            }

            if let still = message["isStill"] as? Bool {
                self.isWristStill = still
            }

            print("📥 Received from Watch → tracking: \(self.isTracking), flat: \(self.isWristFlat), still: \(self.isWristStill)")
        }
    }
}
