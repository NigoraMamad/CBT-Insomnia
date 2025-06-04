import SwiftUI

struct OnboardingPage1: View {
    
 
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 0)
                        .padding(.top, 10)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    HStack {
                        Text("HI, I'M")
                            .font(.krungthep(.regular, relativeTo: .body))
                            .foregroundColor(.white)
                        
                        Text("SORTIE!")
                            .font(.krungthep(.regular, relativeTo: .body))
                            .foregroundColor(Color.accent)
                    }
                    
                    Text("YOUR PERSONAL SLEEPING COACH")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    RobotView()
                    
                    Spacer()
                }
                
                Spacer()
                
                
                OnboardingNavigationButton(
                                  label: "NEXT",
                                  destination: OnboardingPage2()
                              )
                    .padding(.bottom, 30)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingPage1()
}
