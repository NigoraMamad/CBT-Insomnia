//
//  WakeUpView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 06/06/25.
//

import SwiftUI

struct WakeUpView: View {
    
    @AppStorage("wakeUpTime") private var userWakeUpTime: String = ""
    
    @State private var wakeUpTime = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    @State private var selectedDuration: SleepDuration = .one
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 25) {
                Text("THIS IS GOING TO BE YOUR \nSLEEP TIME FOR THE WEEK")
                    .foregroundColor(.accent)
                    .font(.krungthep(.regular, relativeTo: .title2))
                
                Divider().background(Color.white)
                
                HStack {
                    Text("Getting up at")
                    Spacer()
                }
                
                DatePicker("", selection: $wakeUpTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                    
                    Text("PAY ATTENTION!\nYOU WON’T BE ABLE TO CHANGE THE WINDOW UNTIL THE BEGINNING OF NEXT WEEK!")
                        .multilineTextAlignment(.center)
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
                    destination: ContentView()
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
    WakeUpView()
}
