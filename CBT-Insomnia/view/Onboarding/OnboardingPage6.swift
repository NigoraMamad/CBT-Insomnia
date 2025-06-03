//
//  OnboardingPage6.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 30/05/25.
//




import SwiftUI

struct OnboardingPage6: View {
    @State private var selectedSleepOption: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
               
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 3.0 / 6.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("NOTIFICATIONS ARE ESSENTIAL")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Text("TO MAKE THE TERAPY AS")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Text("EFFICIENT")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 60)
                    
                    Image("test")
                    
                    Spacer().frame(height: 30)
                    
                   
                    Spacer()
                }
                
                
                OnboardingNavigationButton(label: "enable notifications", destination: OnboardingPage5())
                    .padding(.bottom, 30)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}



#Preview {
    OnboardingPage6()
}
