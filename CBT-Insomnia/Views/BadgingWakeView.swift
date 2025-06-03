//
//  BadgingWakeView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI

struct BadgingWakeView: View {
    
    @StateObject private var stepCounter = StepCounter()
    @State private var isStepCounterShown: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("Hi there! I see you just woke up! Let's take some steps together to start your day.")
                    .kerning(2)
                
                RobotView()
                
                BadgeSleepButton(label: "Start tracking", isActive: true) {
                    stepCounter.startTracking()
                    isStepCounterShown = true
                }
                .font(.dsDigital(.regular, relativeTo: .callout))
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isStepCounterShown) {
            StepsView(stepCounter: stepCounter)
        }
        .ignoresSafeArea()
        .font(.dsDigital(.regular, relativeTo: .title))
        .foregroundStyle(.white)
    }
}

#Preview {
    BadgingWakeView()
}
