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
                        Text("Hi, I'm")
                            .font(Font.custom("LiquidCrystal-Regular", size: 20))
                            .foregroundColor(.white)
                        
                        Text("Sortie!")
                            .font(Font.custom("LiquidCrystal-Regular", size: 20))
                            .foregroundColor(Color.accent)
                    }
                    
                    Text("Your personal sleeping coach")
                        .font(Font.custom("LiquidCrystal-Regular", size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(height: 100)
                    
                    RobotView()
                    
                    Spacer()
                }
                
                Spacer()
                
                
                OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage2())
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
