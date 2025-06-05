
import SwiftUI

struct OnboardingPage4: View {
    
    @State private var selectedSleepOption: String = ""

    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
               
                VStack(spacing: 0) {
                    ProgressBarOnboarding(progress: 3.0 / 6.0)
                        .padding(.top, 10)
                    
                    Spacer().frame(height: 50)
                    
                    Text("HOW MANY HOURS DO YOU")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    Text("USUALLY SLEEP AT NIGHT?")
                        .font(.krungthep(.regular, relativeTo: .body))
                        .foregroundColor(.white)
                    
                    
                    RobotView()
                    
                    
                    VStack(spacing: 20) {
                        
                        SelectableSleepOption(
                            label: "LESS THAN 5 HOURS",
                            isSelected: selectedSleepOption == "LESS THAN 5 HOURS",
                            onTap: {
                                selectedSleepOption = "LESS THAN 5 HOURS"
                            }
                        )
                        
                        SelectableSleepOption(
                            label: "5-7 HOURS",
                            isSelected: selectedSleepOption == "5-7 HOURS",
                            onTap: {
                                selectedSleepOption = "5-7 HOURS"
                            }
                        )
                        
                        SelectableSleepOption(
                            label: "MORE THAN 8 HOURS",
                            isSelected: selectedSleepOption == "MORE THAN 8 HOURS",
                            onTap: {
                                selectedSleepOption = "MORE THAN 8 HOURS"
                            }
                        )
                        
                    }
                    .padding(20)
                    
                    Spacer()
                }
                
                
                OnboardingNavigationButton(label: "NEXT", destination: OnboardingPage5(), canProceed: { !selectedSleepOption.isEmpty })
                    .padding(.bottom, 30)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}



struct SelectableSleepOption: View {
    
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(label)
            .font(.krungthep(.regular, relativeTo: .title2))
            .foregroundColor(isSelected ? .black : .white)
            .frame(height: 40)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(isSelected ? .white : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.white, lineWidth: 2)
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    onTap()
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}


#Preview {
    OnboardingPage4()
}
