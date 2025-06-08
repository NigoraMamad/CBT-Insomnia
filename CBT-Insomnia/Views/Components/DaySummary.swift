//
//  DaySummary.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 06/06/25.
//

import SwiftUI

struct DaySummary: View {
    
    var body: some View {
        
        VStack {
            
             // MARK: PERCENT
            Text("75%")
                .font(.dsDigital(.bold, size: 143))
                .foregroundStyle(.accent)
                .shadow(color: .accent.opacity(0.6), radius: 10, x: 0, y: 0)
                .shadow(color: .accent.opacity(0.4), radius: 30, x: 0, y: 0)
                .padding(.top, 10)
            Text("Efficiency")
                .foregroundStyle(.white)
                .padding(.bottom, 40)
            
            // MARK: HOURS SLEPT VS GOAL SLEEP HOURS
            Text("Today you slept 6:20 out of 8 hours")
                .foregroundStyle(.white)
            
            // MARK: PROGRESS BARR
            GeometryReader { geo in
                let fullWidth = geo.size.width
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.tertiary)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 75 != 0.0 ? max(20, 0*fullWidth/100) : 0)
                } // -> ZStack
            } // -> GeometryReader
            .frame(height: 20)
            .padding(.bottom, 30)
            
            Divider()
                .frame(minHeight: 1)
                .background(.white)
                .padding(.bottom, 20)
            
            // MARK: SLEEP INSIGHTS
            ForEach(0..<3) { _ in
                HStack {
                    Image(systemName: "bed.double.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 30, maxHeight: 20)
                        
                    VStack(alignment: .leading) {
                        Text("SLEEP DURATION")
                            .foregroundStyle(.accent)
                        Text("28/40")
                    }
                    Spacer()
                    Text("7:00")
                }
                .foregroundStyle(.white)
                .padding(.bottom, 30)
                  
            } // ForEach
            
        } // -> VStack
        .preferredColorScheme(.dark)
        
    } // -> body
    
} // -> DayAnalysis

#Preview {
    DaySummary()
} // -> Preview
