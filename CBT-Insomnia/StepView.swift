//
//  StepView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 27/05/25.
//

import SwiftUI

struct StepView: View {
    @StateObject private var stepCounter = StepCounter()

    var body: some View {
        VStack {
            Text("Steps: \(stepCounter.stepCount)")
                .font(.largeTitle)
                .padding()

            Button("Start Tracking") {
                stepCounter.startTracking()
            }

            Button("Stop Tracking") {
                stepCounter.stopTracking()
            }
        }
    }
}
