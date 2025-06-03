//
//  OnboardingPage7.swift
//  CBT-Insomnia
//
//  Created by Gianpietro Panico on 03/06/25.
//

//
//  OnboardingPage6.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 30/05/25.
//




import SwiftUI

struct OnboardingPage7: View {
    @State private var selectedSleepOption: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
               
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 6.0 / 6.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("you're all set!")
                        .font(Font.custom("LiquidCrystal-Regular", size: 30))
                        .foregroundColor(.white)
                    
                    
                    Spacer().frame(height: 60)
                    
                    Image("test")
                    
                    Spacer().frame(height: 30)
                    
                   
                    Spacer()
                }
                
                
                OnboardingNavigationButton(label: "start", destination: OnboardingPage7())
                    .padding(.bottom, 30)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}



#Preview {
    OnboardingPage7()
}
