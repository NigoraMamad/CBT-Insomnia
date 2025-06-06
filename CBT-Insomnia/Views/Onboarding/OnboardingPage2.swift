import SwiftUI

struct OnboardingPage2: View {

    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 1.0 / 7.0)
                        .padding(.top, 10)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    VStack(spacing: 5) {
                        Text("I WILL SUPPORT YOU")
                            .font(.krungthep(.regular, relativeTo: .body))
                            .foregroundColor(.white)
                        
                        Text("THROUGHOUT YOUR JOURNEY IN")
                            .font(.krungthep(.regular, relativeTo: .body))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 6) {
                            Text("OVERCOMING")
                                .font(.krungthep(.regular, relativeTo: .body))
                                .foregroundColor(.white)
                            
                            Text("INSOMNIA.")
                                .font(.krungthep(.regular, relativeTo: .body))
                                .foregroundColor(Color.accent)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    
                    RobotView()
                    
                    Spacer()
                }
                
                
                OnboardingNavigationButton(label: "NEXT",  destination: OnboardingPage3())
                    .padding(.bottom, 30)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingPage2()
}
