//
//  ContentView.swift
//  SleepDetection Watch App
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var motion = MotionManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("⌚ Apple Watch")
                .font(.headline)

            Button(action: {
                if motion.isTracking {
                    motion.stopMonitoring()
                } else {
                    motion.startMonitoring()
                }
            }) {
                Text(motion.isTracking ? "🟢 Tracking…" : "Start Tracking")
                    .padding()
                    .background(motion.isTracking ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
