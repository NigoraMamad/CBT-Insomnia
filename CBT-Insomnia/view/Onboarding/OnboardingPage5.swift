//
//  OnboardingPage5.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 30/05/25.
//


import SwiftUI
import UserNotifications


struct OnboardingPage5: View {
    @State private var goToNextPage = false
    let font = Font.custom("LiquidCrystal-Regular", size: 20)
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Contenuto principale
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 4.0 / 6.0)
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
                
                OnboardingNavigationButton5(
                    label: "enable notifications",
                    destination: OnboardingPage6(),
                    customAction: { completion in
                        requestNotificationPermission {
                            completion() 
                        }
                    }
                )
                .padding(.bottom, 30)
            }
            .padding()
        }
    }
    
    
    func requestNotificationPermission(completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}


struct OnboardingNavigationButton5<Destination: View>: View {
    var label: String
    var destination: Destination
    var waitForPermission: Bool = false
    var customAction: ((@escaping () -> Void) -> Void)? = nil
    
    @State private var navigate = false
    
    var body: some View {
        VStack {
            Button(action: {
                if let action = customAction {
                    // Passa la closure per attivare navigazione manuale
                    action {
                        navigate = true
                    }
                } else {
                    navigate = true
                }
            }) {
                Text(label)
                    .font(Font.custom("LiquidCrystal-Regular", size: 24))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            NavigationLink(
                destination: destination,
                isActive: $navigate
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
}
#Preview {
    OnboardingPage5()
}
