//
//  WristDetectionView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//
import SwiftUI

struct WristDetectionView: View {
    @StateObject var receiver = WatchReceiver()

    var body: some View {
        VStack(spacing: 20) {
            Text("Good Michele")
                .font(.title2)
                .bold()

            if receiver.hasWokenUp {
                Text("🎉 You woke up!")
                    .font(.title)
                    .foregroundColor(.green)
                    .bold()
            } else if receiver.isTracking {
                Text("🟢 Tracking…")
                    .font(.headline)
                    .foregroundColor(.green)

                Text("👣 Steps: \(receiver.stepCount)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)

                Text(receiver.isWristFlat ? "🛏 Wrist is flat" : "📱 Not flat")
                    .foregroundColor(receiver.isWristFlat ? .blue : .red)

                Text(receiver.isWristStill ? "😌 Wrist is still" : "🙆‍♀️ Moving")
                    .foregroundColor(receiver.isWristStill ? .blue : .red)

                if receiver.isWristFlat && receiver.isWristStill {
                    Text("✅ Likely lying down")
                        .bold()
                        .foregroundColor(.purple)
                }
            } else {
                Text("⏹ Tracking not active")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
