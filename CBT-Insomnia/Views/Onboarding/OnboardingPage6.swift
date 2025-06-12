

import SwiftUI
import UserNotifications


struct OnboardingPage6: View {
    @State private var goToNextPage = false
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Contenuto principale
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 5.0 / 7.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("NOTIFICATIONS ARE ESSENTIAL")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("TO GUIDE YOU THROUGH YOUR")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("SLEEP JOURNEY")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Spacer().frame(height: 10)
                    
                    RobotView()
                    
                    Spacer().frame(height: 30)
                    
                    Spacer()
                }
                
                OnboardingNavigationButton5(
                    label: "ENABLE NOTIFICATIONS",
                    destination: OnboardingPage7(),
                    customAction: { completion in
                        NotificationManager.shared.requestPermissionAndSchedule { //permission
                            //NotificationManager.shared.testImmediateNotification()//test notification
                            completion() //next page
                        }
                    }
                )
                .padding(.bottom, 30)
            }
            .padding()
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
                    .font(.krungthep(.regular, relativeTo: .title2))
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
    OnboardingPage6()
}
