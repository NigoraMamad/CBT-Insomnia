//
//  WakeUpView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 06/06/25.
//

import SwiftUI

struct OnboardingPage5: View {
    
    @State private var wakeUpTime = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                ProgressBarOnboarding(progress: 4.0 / 7.0)
                    .padding(.top, 10)

                Spacer().frame(height: 50)

                Text("LET'S SET YOUR WAKE UP TIME!")
                    .font(.krungthep(.regular, relativeTo: .body))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            
                Spacer().frame(height: 50)
                
                DatePicker("", selection: $wakeUpTime, displayedComponents: [.hourAndMinute])
                    .font(.krungthep(.regular, relativeTo: .title3))
                    .foregroundColor(.white)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer().frame(height: 50)
                
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.yellow)
                    
                    Text("PAY ATTENTION!\nYOU WON’T BE ABLE TO CHANGE THE WAKE UP TIME UNTIL THE BEGINNING OF NEXT WEEK!")
                        .multilineTextAlignment(.center)
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                        .padding()
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.csGray.opacity(0.4))
                }
                
                Spacer()
                
                
                OnboardingNavigationButton(
                                    label: "Done",
                                    destination: OnboardingPage6(),
                                    customAction: { proceed in
                                        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
                                        UserDefaultsService.shared.saveWakeUpTime(components)
                                        proceed()
                                    }
                                )
                                .padding(.bottom, 30)
                                .padding(.horizontal)
                
                
                
            }
            .padding()
            .foregroundColor(.white)
            .font(.krungthep(.regular, relativeTo: .body))
        }
    }
}

#Preview {
    OnboardingPage5()
}
