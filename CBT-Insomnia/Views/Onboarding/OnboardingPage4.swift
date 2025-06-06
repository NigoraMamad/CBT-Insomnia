import SwiftUI

struct OnboardingPage4: View {
    
    @State private var selectedSleepOption: SleepDuration = .eight
    @State private var showAlert = false

    private let defaults = UserDefaultsService()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 3.0 / 7.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("HOW MANY HOURS DO YOU")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("USUALLY SLEEP AT NIGHT?")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    RobotView()
                    
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 20) {
                        Picker("Select sleep duration", selection: $selectedSleepOption) {
                            ForEach(SleepDuration.allCases, id: \.self) { duration in
                                Text(duration.displayText)
                                // .font(.krungthep(.regular, relativeTo: .title3))
                                    .foregroundColor(.white)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 150)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(20)
                    
                    Spacer()
                }
                
                OnboardingNavigationButton(
                                    label: "NEXT",
                                    destination: OnboardingPage5(),
                                    customAction: { proceed in
                                        defaults.saveSleepDuration(selectedSleepOption)
                                        print("✅ Saved sleep duration: \(selectedSleepOption.rawValue)")
                                        proceed()
                                    }
                                )
                .padding(.bottom, 30)
                .padding(.horizontal)
                .alert("Please select a sleep duration", isPresented: $showAlert) {
                                   Button("OK", role: .cancel) { }
                               }
            }
            .padding()
            .onAppear {
                            if let saved = defaults.getSleepDuration() {
                                selectedSleepOption = saved
                                print("🔁 Loaded previous duration: \(saved.rawValue)")
                            }
                        }
        }
    }
}

extension SleepDuration {
    var displayText: String {
        let hours = dateComponents.hour ?? 0
        let minutes = dateComponents.minute ?? 0
        
        switch (hours, minutes) {
        case (_, 0):
            return "\(hours)h"
        case (0, _):
            return "\(minutes)m"
        default:
            return "\(hours)h \(minutes)m"
        }
    }
}

#Preview {
    OnboardingPage4()
}
