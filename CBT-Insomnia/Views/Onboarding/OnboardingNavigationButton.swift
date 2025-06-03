
import SwiftUI

struct OnboardingNavigationButton<Destination: View>: View {
    
    var label: String
    var destination: Destination
    var customAction: (() -> Void)? = nil

    var body: some View {
        NavigationLink(destination: destination) {
            Text(label)
                .font(Font.custom("LiquidCrystal-Regular", size: 24))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.white)
        }
                .simultaneousGesture(TapGesture().onEnded {
                    customAction?()
                })
                .padding(.horizontal)
    }
}

#Preview {
    OnboardingNavigationButton(label: "Next", destination: OnboardingPage1())
}
