//
//  EfficiencySummarySheet.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//


import SwiftUI

struct WeeklyEfficiencySheet: View {
    @ObservedObject var viewModel: SleepAdjustmentViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Last Week's Sleep Efficiency")
                .font(.title2)
                .bold()

            Text("\(Int(viewModel.efficiencyLastWeek))%")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(viewModel.eligibleForBonus ? .green : .gray)

            if viewModel.eligibleForBonus {
                Text("Great job! You can now add 15 minutes to your sleep window.")

                Button("Add 15 min to Wake-up Time") {
                    viewModel.add15Minutes(to: .wake)
                    viewModel.showEfficiencySheet = false
                }

                Button("Add 15 min to Bed Time") {
                    viewModel.add15Minutes(to: .bed)
                    viewModel.showEfficiencySheet = false
                }

                Button("Keep Current Schedule") {
                    viewModel.add15Minutes(to: .keep)
                    viewModel.showEfficiencySheet = false
                }
            } else {
                Text("Keep going! Aim for ≥ 90% efficiency to unlock bonus.")
                Button("Got it") {
                    viewModel.showEfficiencySheet = false
                }
            }
        }
        .padding()
    }
}
