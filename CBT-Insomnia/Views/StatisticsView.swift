//
//  StatisticsView.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 19/05/25.
//

import SwiftUI

struct StatisticsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var manager: HealthManager
    
    @State private var selectedPeriod: Period = .day
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                
                // MARK: PICKER
                CustomPicker(selection: $selectedPeriod, options: Period.allCases)
                   .padding(.horizontal, 50)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                
                // MARK: STEPS TEXT
                HStack {
                    Spacer()
                    Button {
                        //
                    } label: {
                        Image(systemName: "chevron.backward")
                    } // -> Button
                    Spacer()
                    Button {
                        //
                    } label: {
                        Text(selectedPeriod == .day ? "MONDAY, May 2, 2025" : "Week 1: May 2 - 8")
                    } // -> Button
                    Spacer()
                    Image(systemName: "chevron.forward")
                    Spacer()
                } // -> HStack
                .foregroundStyle(.white)
                .padding(.bottom, 20)
                
                switch selectedPeriod {
                    case .day: DaySummary()
                    case .week: WeekSummary()
                } // switch selectedPeriod
                
                Spacer()
                
            } // -> VStack
            .padding(.horizontal)
            
        } // -> ZStack
        // MARK: BG COLOR
        .preferredColorScheme(.dark)
        .font(.krungthep(.regular, relativeTo: .callout))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                } // -> Button
            } // -> ToolbarItem
            ToolbarItem(placement: .principal) {
                Text("STATISTICS")
                    .font(.krungthep(.regular, relativeTo: .callout))
            }
        } // -> toolbar
        
    } // -> body
    
} // -> HomeView

#Preview {
    @Previewable @State var manager = HealthManager()
    StatisticsView()
        .environmentObject(manager)
} // -> Preview
