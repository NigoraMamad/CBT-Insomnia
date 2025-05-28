//
//  WatchReceiver 2.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//


import WatchConnectivity
import SwiftUI

class WatchReceiver: NSObject, WCSessionDelegate, ObservableObject {
    @Published var isWristFlat = false
    @Published var isWristStill = false
    @Published var isTracking = false

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.isTracking = message["isTracking"] as? Bool ?? self.isTracking
            self.isWristFlat = message["isFlat"] as? Bool ?? self.isWristFlat
            self.isWristStill = message["isStill"] as? Bool ?? self.isWristStill
        }
    }
}
