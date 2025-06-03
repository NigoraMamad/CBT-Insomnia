import SwiftUI

struct OnboardingPage2: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
               
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 1.0 / 6.0)
                        .padding(.top, 10)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    VStack(spacing: 5) {
                        Text("I will support you")
                            .font(Font.custom("LiquidCrystal-Regular", size: 20))
                            .foregroundColor(.white)
                        
                        Text("throughout your journey in ")
                            .font(Font.custom("LiquidCrystal-Regular", size: 20))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 6) {
                            Text("overcoming")
                                .font(Font.custom("LiquidCrystal-Regular", size: 20))
                                .foregroundColor(.white)
                            
                            Text("insomnia.")
                                .font(Font.custom("LiquidCrystal-Regular", size: 20))
                                .foregroundColor(Color.accent)
                        }
                    }
                    
                    Spacer().frame(height: 100)
                    
                    Image("test")
                    
                    Spacer()
                }

              
                OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage3())
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
