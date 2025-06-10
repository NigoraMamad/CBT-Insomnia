import SwiftUI

struct OnboardingPage3: View {
    
    @AppStorage("userName") private var name: String = ""

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 2.0 / 7.0)
                        .padding(.top, 10)

                    Spacer().frame(height: 50)

                    Text("WHAT'S YOUR NAME")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)

                    Spacer().frame(height: 10)

                    Text("THIS HELPS US TO PERSONALIZE YOUR EXPERIENCE")
                        .font(.krungthep(.regular, relativeTo: .caption))
                        .foregroundColor(Color.gray)

                    Spacer().frame(height: 30)

                    RobotView()

                    RetroDigitTextField(text: $name)
                        .padding(.top, 30)
                        .padding(.horizontal, 20)

                    Spacer()
                        .frame(height: 80)
                }

                VStack {
                    Spacer()
                    OnboardingNavigationButton(
                        label: "NEXT",
                        destination: OnboardingPage4(),
                        canProceed: { !name.trimmingCharacters(in: .whitespaces).isEmpty }
                    )
                    .frame(height: 44)
                    .font(.krungthep(.regular, relativeTo: .callout))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                }
                
            }
        }
    }
}

struct RetroDigitTextField: View {
    
    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty && !isFocused {
                Text("INSERT YOUR NAME")
                    .font(.krungthep(.regular, relativeTo: .title))
                    .foregroundColor(.white)
            }

            TextField("", text: $text)
                .focused($isFocused)
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
