

import SwiftUI
import HealthKit

struct OnboardingPage7: View {
    
    @State private var selectedSleepOption: String = ""

    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 6.0 / 7.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("ALLOW THE CONNECTION TO")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("HEALTH IN ORDER TO LET ME GATHER")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("DATA ABOUT YOUR SLEEP!")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("IT IS CRUCIAL!")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 40)
                    
                    RobotView()
                    
                    Spacer().frame(height: 10)
                    
                    
                    Spacer()
                }
                
                OnboardingNavigationButton5(
                    label: "ENABLE HEALTH",
                    destination: OnboardingPage8(),
                    customAction: { completion in
                        requestHealthKitPermission {
                            completion()
                        }
                    }
                )
                .padding(.bottom, 30)
            }
            .padding()
        }
    }
}

func requestHealthKitPermission(completion: @escaping () -> Void) {
#if targetEnvironment(simulator)
    print("Simulator: HealthKit not available, bypass request")
    completion()
    return
#endif
    
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
    OnboardingPage7()
}
