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
            self.isWristFlat = message["isFlat"] as? Bool ?? false
            self.isWristStill = message["isStill"] as? Bool ?? false
        }
    }
}

