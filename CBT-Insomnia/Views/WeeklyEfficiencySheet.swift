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
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("Last Week's Sleep Efficiency")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(Int(viewModel.efficiencyLastWeek))%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(viewModel.eligibleForBonus ? .green : .gray)
                
                if viewModel.eligibleForBonus {
                    Text("Great job! You’ve earned a bonus. \nWhere do you want to add 15 minutes?")
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Button("Wake-up Time") {
                            viewModel.add15Minutes(to: .wake)
                            dismiss()
                        }
                        Spacer()
                        
                        Button("Bed Time") {
                            viewModel.add15Minutes(to: .bed)
                            dismiss()
                        }
                    }
                    
                    Button("Keep Current Schedule") {
                        viewModel.add15Minutes(to: .keep)
                        dismiss()
                    }
                } else {
                    Text("Keep going! Aim for ≥ 90% to unlock bonus sleep time.")
                        .multilineTextAlignment(.center)
                    
                    Button("Got it") {
                        viewModel.add15Minutes(to: .keep)
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    let vm = SleepAdjustmentViewModel(context: ModelContainer.preview.mainContext)
    vm.efficiencyLastWeek = 93
    vm.eligibleForBonus = true
    vm.showEfficiencySheet = true

    return WeeklyEfficiencySheet(viewModel: vm)
        .modelContainer(.preview)
}

