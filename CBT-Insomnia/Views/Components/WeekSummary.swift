//
//  WeekSummary.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import SwiftUI

struct WeekSummary: View {
    
    @EnvironmentObject var manager: HealthManager
    
    @State private var selectedPeriod: Period = .day
    
    var efficiency = 0.0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack(alignment: .center) {
                
                // MARK: SLEEP DATA
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // MARK: SUB-TITLE
                        Text("AVG SLEEP EFFICIENCY")
                            .foregroundStyle(.white)
                            .padding(.top, 20)
                        
                        // MARK: SLEEP EFF SUMMARY
                        HStack(alignment: .bottom, spacing: 15) {
                            Text("82%")
                                .foregroundStyle(.white)
                                .font(.dsDigital(.bold, relativeTo: .largeTitle))
                            HStack(spacing: 2) {
                                Image(systemName: "arrow.up")
                                    .resizable()
                                    .foregroundColor(.accent)
                                    .font(.krungthep(.regular, relativeTo: .title2))
                                    .frame(width: 7.5, height: 12.5)
                                Text("2.5%")
                                    .font(.krungthep(.regular, relativeTo: .title2))
                                    .foregroundStyle(.accent)
                            } // -> HStack
                            .shadow(color: .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                            .shadow(color: .accent.opacity(0.4), radius: 30, x: 0, y: 0)
                            
                        } // -> HStack
                        
                        Text("Compared to 7h40m from last week")
                            .foregroundStyle(.gray)
                        
                    } // -> VStack
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: SHINEE ICON
                    SparkleIcon()
                        .frame(width: 25, height: 25)
                    
                } // -> HStack
                .padding(.bottom, 20)
                
                // MARK: TABLE/CHARTS
                VStack(spacing: 20) {
                    
                    let days = Days.allCases
                    
                    ForEach(days, id: \.self) { day in
                        
                        let date = manager.dateFor(day: day)!
                        
                        let efficiency = manager.sleepEfficiencies.first(where: {
                            Calendar.current.isDate($0.date, inSameDayAs: date)
                            
                        })?.efficiency ?? 0.0
                        
                        HStack {
                            
                            Text(day.shortLabel)
                                .foregroundStyle(.white)
                                .font(.krungthep(.regular, relativeTo: .title2))
                                .frame(width: 30, alignment: .leading)
                            
                            GeometryReader { geo in
                                let fullWidth = geo.size.width
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.secondary)
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.accent)
                                        .frame(width: efficiency != 0.0 ? max(10, efficiency*fullWidth/100) : 0.0)
                                        .shadow(color: .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                                } // -> ZStack
                            } // -> GeometryReader
                            .frame(height: 30)
                            
                            Text("\(String(format: "%.0f", efficiency))%")
                                .foregroundStyle(.white)
                                .frame(width: 45, alignment: .trailing)
                            
                        } // -> HStack
                        
                        if day != days[days.count-1] {
                            Divider()
                                .frame(minHeight: 1)
                                .background(.gray.opacity(0.3))
                        } // -> if
                        
                    } // -> ForEach
                    
                } // -> VStack
                
                Spacer()
                
            } // -> VStack
            
        } // -> ZStack
        // MARK: BG COLOR
        .preferredColorScheme(.dark)
        .navigationTitle("STATISTICS")
        .task {
            manager.calculateSleepEfficiency()
        }
        
    } // -> body
    
} // -> SleepSummary

#Preview {
    @Previewable @State var manager = HealthManager()
    WeekSummary()
        .environmentObject(manager)
} // -> Preview
