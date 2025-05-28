//
//  ContentView.swift
//  SleepDetection Watch App
//
//  Created by Nigorakhon Mamadalieva on 28/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var motion = MotionManager()

    var body: some View {
        VStack {
            Button("Start Tracking") {
                motion.startMonitoring()
            }
        }
    }
}


#Preview {
    ContentView()
}
