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
            Button(action: {
                if motion.isTracking {
                    motion.stopMonitoring()
                } else {
                    motion.startMonitoring()
                }
            }) {
                Text(motion.isTracking ? "Tracking..." : "Start Tracking")
                    .font(.custom("Krungthep", size: 20))
                    .multilineTextAlignment(.center)
                    .frame(width: 150, height: 150)
                    .background(motion.isTracking ? Color.gray : .accent)
                    .foregroundColor(.black)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }
}

