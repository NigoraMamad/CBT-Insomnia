//
//  Untitled.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 30/05/25.
//

import SwiftUI

import SwiftUI

struct OnboardingPage3: View {
    
    @State private var age: String = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
               
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 2.0 / 6.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("how old are you?")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 20)
                    
                    Text("this helps us personalize your experience")
                        .font(Font.custom("LiquidCrystal-Regular", size: 15))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 50)
                    
                    Image("test")
                    
                    Spacer().frame(height: 40)
                    
                    RetroDigitTextField(text: $age)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
              
                OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage4())
                    .padding(.bottom, 30)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}



struct RetroDigitTextField: View {
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text("INSERT YOUR AGE")
                    .font(Font.custom("LiquidCrystal-Regular", size: 26))
                    .foregroundColor(Color.accent.opacity(0.6))
            }

            TextField("", text: $text)
                .font(Font.custom("LiquidCrystal-Regular", size: 26))
                .foregroundColor(Color.accent)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.accent, lineWidth: 2)
                )
        }
    }
}

#Preview {
    OnboardingPage3()
}
