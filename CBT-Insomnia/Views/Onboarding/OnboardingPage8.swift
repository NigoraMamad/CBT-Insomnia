//
//  OnboardingPage7.swift
//  CBT-Insomnia
//
//  Created by Gianpietro Panico on 03/06/25.
//

import SwiftUI

struct OnboardingPage8: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var sleepDataService = SleepDataService()
    
    @AppStorage("onboardingCompleted") var onboardingCompleted = false
    @State private var navigate = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                ProgressBarOnboarding(progress: 7.0 / 7.0)
                    .padding(.top, 10)

                Spacer().frame(height: 50)

                Text("YOU'RE ALL SET!")
                    .font(.krungthep(.regular, relativeTo: .body))
                    .foregroundColor(.white)

                Spacer().frame(height: 60)

                RobotView()

                Spacer()

                Button(action: {
                    onboardingCompleted = true
                    navigate = true
                }) {
                    Text("START")
                        .font(.krungthep(.regular, relativeTo: .title))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                }
                .padding(.bottom, 30)
                .padding(.horizontal)

                NavigationLink(
                    destination: ContentView(context: modelContext)
                        .environmentObject(sleepDataService)
                        .navigationBarBackButtonHidden(true),
                    isActive: $navigate
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingPage8()
}
