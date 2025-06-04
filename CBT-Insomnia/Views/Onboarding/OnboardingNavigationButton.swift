import SwiftUI

struct OnboardingNavigationButton<Destination: View>: View {
    var label: String
    var destination: Destination
    var customAction: ((@escaping () -> Void) -> Void)? = nil
    var canProceed: () -> Bool = { true } // funzione dinamica per abilitazione
    
    @State private var navigate = false
    
    var body: some View {
        VStack {
            Button(action: {
                guard canProceed() else { return }
                
                if let action = customAction {
                    action {
                        navigate = true
                    }
                } else {
                    navigate = true
                }
            }) {
                Text(label)
                    .font(.krungthep(.regular, relativeTo: .title))
                    .foregroundColor(canProceed() ? .black : Color(hex: "#808080"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 0)
                            .fill(canProceed() ? Color.white : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color(hex: "#808080"), lineWidth: canProceed() ? 0 : 2)
                            )
                    )
            }
            .padding(.horizontal)
            
            NavigationLink(destination: destination, isActive: $navigate) {
                EmptyView()
            }
            .hidden()
        }
    }
}

#Preview {
    OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage1())
}
