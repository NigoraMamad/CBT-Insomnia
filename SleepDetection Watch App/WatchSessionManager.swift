//
//  WatchSessionManager.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//


import WatchConnectivity


class WatchSessionManager: NSObject, WCSessionDelegate {
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // ✅ Required for watchOS
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }

    // ✅ Optional: If you're using background transfers, handle them here
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Reachability changed: \(session.isReachable)")
    }
}
