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
        VStack {
            Text(receiver.isWristFlat ? "🛏️ Wrist is flat" : "📱 Not flat")
            Text(receiver.isWristStill ? "😌 Wrist is still" : "🙆‍♀️ Moving")
        }
        .padding()
    }
}
