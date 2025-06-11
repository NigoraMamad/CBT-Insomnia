//
//  StepsView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 03/06/25.
//

import SwiftUI

struct StepsView: View {
    
    @Environment(\.modelContext) private var modelContext
   
    @ObservedObject var stepCounter: StepCounter
    @State private var isWaitingForRealSteps = false
    @State private var isMainViewShown = false
    @State private var hasCompletedSleepSession = false

    var body: some View {
        NavigationStack{
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image(systemName: "figure.walk")
                        .resizable()
                        .frame(width: 50, height: 80)
                        .foregroundStyle(.accent)
                        .padding(.bottom, 20)
                    
                    Group {
                        if stepCounter.isTracking {
                            VStack(spacing: 20) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                                    .scaleEffect(2)
                                Text("Take 10 Steps")
                            }
                        } else if stepCounter.isStoppedTracking {
                            Text("Congrats! \nYour day starts now!")
                                .multilineTextAlignment(.center)
                        } else {
                            Spacer().frame(height: 80)
                        }
                    }
                    .frame(height: 120)
                    
                    Spacer()
                }
                
                
                if stepCounter.isStoppedTracking {
                    VStack {
                        Spacer()
                        BadgeSleepButton(label: "OK!", isActive: true) {
                            isMainViewShown = true
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
           
        }
        .font(.krungthep(.regular, relativeTo: .title))
        .foregroundColor(.white)
        .fullScreenCover(isPresented: $isMainViewShown) {
            ContentView(context: modelContext)
        }
        .onChange(of: stepCounter.isStoppedTracking) { _, newValue in
            // Save badge-out time when step tracking stops
            if newValue && !hasCompletedSleepSession {
                print("StepsView: Step tracking stopped, completing sleep session")
                SleepDataService.shared.completeSleepSession(context: modelContext)
                hasCompletedSleepSession = true
            }
        }
    }
}
