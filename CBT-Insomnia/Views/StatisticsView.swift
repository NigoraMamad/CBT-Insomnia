//
//  StatisticsView.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 19/05/25.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPeriod: Period = .day
    
    let bedTime: DateComponents
    let wakeTime: DateComponents
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                
                // MARK: PICKER
                CustomPicker(selection: $selectedPeriod, options: Period.allCases)
                   .padding(.horizontal, 50)
                   .padding(.top, 10)
                   .padding(.bottom, 30)
                
                switch selectedPeriod {
                    case .day: DaySummary()
                    case .week: WeekSummary()
                } // switch selectedPeriod
                
                Spacer()
                
            } // -> VStack
            .padding(.horizontal)
            
        } // -> ZStack
        .font(.krungthep(.regular, relativeTo: .callout))
        // MARK: HEADER
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
            } // -> ToolbarItem
        } // -> toolbar
        
    } // -> body
    
} // -> HomeView

#Preview {
    StatisticsView(
        bedTime: DateComponents(hour: 0, minute: 30),
        wakeTime: DateComponents(hour: 10, minute: 30)
    ) // -> StatisticsView
} // -> Preview
