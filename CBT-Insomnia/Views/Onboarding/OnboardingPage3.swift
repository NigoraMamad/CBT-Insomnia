import SwiftUI

struct OnboardingPage3: View {
    
    @AppStorage("userName") private var name: String = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        ProgressBarOnboarding(progress: 2.0 / 6.0)
                            .padding(.top, 10)
                        
                        Spacer().frame(height: 50)
                        
                        Text("WHAT'S YOUR NAME")
                            .font(.krungthep(.regular, relativeTo: .body))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 10)
                        
                        Text("THIS HELPS US TO PERSONALIZE YOUR EXPERIENCE")
                            .font(.krungthep(.regular, relativeTo: .caption))
                            .foregroundColor(Color.gray)
                        
                        RobotView()
                        
                        RetroDigitTextField(text: $name)
                            .padding(.top, 30)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 40) // spazio extra per non coprire contenuto
                }

                OnboardingNavigationButton(
                    label: "NEXT",
                    destination: OnboardingPage4(),
                    canProceed: { !name.trimmingCharacters(in: .whitespaces).isEmpty }
                )
                .padding(.bottom, 30)
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


struct RetroDigitTextField: View {
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text("INSERT YOUR NAME")
                    .font(.krungthep(.regular, relativeTo: .title))
                    .foregroundColor(.white)
            }
            
            TextField("", text: $text)
                .font(.krungthep(.regular, relativeTo: .title))
                .foregroundColor(.white)
                .frame(height: 40)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .keyboardType(.default)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(.white)
                )
        }
    }
}



#Preview {
    OnboardingPage3()
}
