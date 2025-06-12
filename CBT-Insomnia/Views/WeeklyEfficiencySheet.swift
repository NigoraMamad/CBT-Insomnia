//
//  EfficiencySummarySheet.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//


import SwiftUI
import SwiftData

struct WeeklyEfficiencySheet: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: SleepAdjustmentViewModel

    var body: some View {
        
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Last Week's Sleep Efficiency")
                    .font(.krungthep(.regular, relativeTo: .title2))
                    .foregroundColor(.accent)
                
                if viewModel.eligibleForBonus {
                    Text("Good job! Your sleep efficiency was 80%+ this week. ")
                        .multilineTextAlignment(.center)
                } else {
                    Text("Keep going! Aim for ≥ 90% to unlock bonus sleep time.")
                        .multilineTextAlignment(.center)
                }
                
                Text("\(Int(viewModel.efficiencyLastWeek))%")
                    .font(.dsDigital(.bold, size: 96))
                    .foregroundColor(viewModel.eligibleForBonus ? .accent : .gray)
                
                if viewModel.eligibleForBonus {
                    Text("As a reward, you can add 15 minutes to your sleep schedule:")
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 80) {
                        Button("Morning") {
                            viewModel.add15Minutes(to: .wake)
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Night") {
                            viewModel.add15Minutes(to: .bed)
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    
                    
                    Button("KEEP CURRENT SCHEDULE") {
                        viewModel.add15Minutes(to: .keep)
                        dismiss()
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                    }
                    .foregroundColor(.black)
                    
                    
                } else {
//                    Text("Keep going! Aim for ≥ 90% to unlock bonus sleep time.")
//                        .multilineTextAlignment(.center)
                    
                    Button("GOT IT") {
                        viewModel.add15Minutes(to: .keep)
                        dismiss()
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                    }
                    .foregroundColor(.black)
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
//            .presentationDetents([.medium])
            .font(.krungthep(.regular, relativeTo: .title3))
        }
    }
}

#Preview {
    let vm = SleepAdjustmentViewModel(context: ModelContainer.preview.mainContext)
    vm.efficiencyLastWeek = 20
    vm.eligibleForBonus = false
    vm.showEfficiencySheet = true

    return WeeklyEfficiencySheet(viewModel: vm)
        .modelContainer(.preview)
}

