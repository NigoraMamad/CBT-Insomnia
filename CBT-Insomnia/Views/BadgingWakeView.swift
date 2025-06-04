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
        NavigationStack{
            ZStack {
                Color.black
                
                VStack {
                    Text("Hi there! I see you just woke up! Let's take some steps together to start your day.")
                    
                    RobotView()
                    
                    BadgeSleepButton(label: "Start tracking", isActive: true) {
                                            stepCounter.startTracking()
                                            isStepCounterShown = true
                                        }
                                        .font(.krungthep(.regular, relativeTo: .callout))

                                        // ✅ Hidden NavigationLink driven by state
                                        NavigationLink(
                                            destination: StepsView(stepCounter: stepCounter),
                                            isActive: $isStepCounterShown
                                        ) {
                                            StepsView(stepCounter:  stepCounter)
                                        }
                    
                    
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .font(.krungthep(.regular, relativeTo: .title2))
        .foregroundStyle(.white)
    }
}

#Preview {
    BadgingWakeView()
}

