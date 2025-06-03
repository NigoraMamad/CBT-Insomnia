//
//  OnboardingPage6.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 30/05/25.
//


import SwiftUI
import HealthKit

struct OnboardingPage6: View {
    @State private var selectedSleepOption: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 5.0 / 6.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("allow the connection to")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Text("health in order to let me gather")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Text("data about your sleep!")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Text("it is crucial!")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 60)
                    
                    Image("test")
                    
                    Spacer().frame(height: 30)
                    
                    
                    Spacer()
                }
                
                
                OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage3())
                    .padding(.bottom, 30)
                    .padding(.horizontal)
                
                
                
                    .padding(.bottom, 30)
                
                    .padding()
            }
        }
    }
}
func requestHealthKitPermission(completion: @escaping () -> Void) {
    let healthStore = HKHealthStore()
    
    guard HKHealthStore.isHealthDataAvailable() else {
        completion()
        return
    }
    
    let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
    
    let typesToRead: Set = [sleepType]
    
    healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
        DispatchQueue.main.async {
            completion()
        }
    }
}


#Preview {
    OnboardingPage6()
}
