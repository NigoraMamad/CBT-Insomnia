//
//  SleepEfficiencyCheckView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//

import SwiftUI

struct SleepEfficiencyCheckView: View {
    @StateObject var viewModel: SleepAdjustmentViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Average Sleep Efficiency: \(Int(viewModel.averageEfficiency))%")

            if viewModel.showAdjustmentOptions {
                Text("🎉 You’ve had great sleep this week!")

                Button("Add 15 min to Wake-up Time") {
                    viewModel.add15Minutes(to: .wake)
                }

                Button("Add 15 min to Bedtime") {
                    viewModel.add15Minutes(to: .bed)
                }

                Button("Keep Current Schedule") {
                    viewModel.add15Minutes(to: .keep)
                }
            }
        }
        .onAppear {
            viewModel.evaluateEfficiencyAndTriggerUI()
        }
        .padding()
    }
}
