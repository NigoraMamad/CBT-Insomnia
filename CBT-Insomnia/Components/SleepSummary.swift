//
//  SleepSummary.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import SwiftUI

struct SleepSummary: View {
    
    @State private var selectedPeriod: Period = .day
    
    var body: some View {
            
        VStack {
            
            // MARK: PICKER
            CustomPicker(selection: $selectedPeriod, options: [Period.allCases[0], Period.allCases[2]])
                .padding(.horizontal, 50)
                .padding(.bottom, 30)
            
            // MARK: SLEEP DATA
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    // MARK: SUB-TITLE
                    Text("AVG SLEEP EFFICIENCY")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                    
                    // MARK: SLEEP EFF SUMMARY
                    HStack(spacing: 15) {
                        Text("82%")
                            .foregroundStyle(.white)
                            .font(.system(size: 25, weight: .bold))
                        HStack(spacing: 2) {
                            Image(systemName: "arrow.up")
                                .resizable()
                                .foregroundColor(.springGreen)
                                .frame(width: 7.5, height: 12.5)
                            Text("2.5%")
                                .foregroundStyle(.springGreen)
                                .font(.system(size: 20))
                        } // -> HStack
                        .shadow(color: .springGreen.opacity(0.8), radius: 10, x: 0, y: 0)
                        .shadow(color: .springGreen.opacity(0.4), radius: 30, x: 0, y: 0)
                        
                    } // -> HStack
                    
                    Text("COMPARED TO 7H40M FROM LAST WEEK")
                        .foregroundStyle(.gray)
                        .font(.system(size: 15))
                    
                } // -> VStack
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: SHINEE ICON
                SparkleIcon()
                    .frame(width: 25, height: 25)
                
            } // -> HStack
            .padding(.bottom, 10)
            
            // MARK: TABLE/CHARTS
            
            VStack {
                
                let days = Days.allCases
                
                ForEach(days, id: \.self) { day in
                    
                    HStack {
                        
                        Text(day.rawValue)
                            .foregroundStyle(.white)
                            .font(.system(size: 15))
                            .frame(width: 40, alignment: .leading)
                        
                        GeometryReader { geo in
                            let fullWidth = geo.size.width
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray.opacity(0.3))
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.accent)
                                    .frame(width: max(10, 10*fullWidth/100))
                                    .shadow(color: .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                            } // -> ZStack
                        } // -> GeometryReader
                        .frame(height: 10)
                        
                        Text("100%")
                            .foregroundStyle(.white)
                            .font(.system(size: 15))
                            .frame(width: 45, alignment: .trailing)
                        
                    } // -> HStack
                    
                    if day != days[days.count-1] {
                        Divider()
                            .frame(minHeight: 1)
                            .background(.gray.opacity(0.3))
                    } // -> if
                    
                } // -> ForEach
                
            } // -> VStack
            
        } // -> VStack
        
    } // -> body
    
} // -> SleepSummary

#Preview {
    SleepSummary()
} // -> Preview
