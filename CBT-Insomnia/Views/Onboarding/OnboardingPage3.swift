
import SwiftUI

struct OnboardingPage3: View {
    
    @State private var age: String = ""

    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView{
                    
                    VStack(spacing: 0) {
                        ProgressBarOnboarding(progress: 2.0 / 6.0)
                            .padding(.top, 10)
                        
                        Spacer().frame(height: 50)
                        
                        Text("HOW OLD ARE YOU ?")
                            .font(.krungthep(.regular, relativeTo: .body))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 10)
                        
                        Text("THIS HELPS US TO PERSONALIZE YOUR EXPERIENCE")
                            .font(.krungthep(.regular, relativeTo: .caption))
                            .foregroundColor(Color.gray)
                        
                        RobotView()
                        
                        VStack(spacing: 20) {
                            
                            SelectableSleepOption(
                                label: "UNDER 18",
                                isSelected: age == "UNDER 18",
                                onTap: {
                                    age = "UNDER 18"
                                }
                            )
                            
                            SelectableSleepOption(
                                label: "18-30",
                                isSelected: age == "18-30",
                                onTap: {
                                    age = "18-30"
                                }
                            )
                            
                            SelectableSleepOption(
                                label: "31-50",
                                isSelected: age == "31-50",
                                onTap: {
                                    age = "31-50"
                                }
                            )
                            
                            SelectableSleepOption(
                                label: "OVER 50",
                                isSelected: age == "OVER 50",
                                onTap: {
                                    age = "OVER 50"
                                }
                            )
                            
                        }
                        
                        .padding(20)
                        Spacer()
                    }
                    
                    OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage4(), canProceed: { !age.isEmpty })
                        .padding(.bottom, 30)
                        .padding(.horizontal)
                }
                .padding()
            }
        }
    }
}


/*
struct RetroDigitTextField: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text("INSERT YOUR AGE")
                    .font(.krungthep(.regular, relativeTo: .title))
                    .foregroundColor(Color.accent.opacity(0.6))
            }
            
            TextField("", text: $text)
                .font(Font.custom("LiquidCrystal-Regular", size: 26))
                .foregroundColor(Color.accent)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.accent, lineWidth: 2)
                )
        }
    }
}
*/

#Preview {
    OnboardingPage3()
}
