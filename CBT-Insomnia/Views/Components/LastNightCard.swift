//
//  LastNightCard.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 30/05/25.
//

import SwiftUI

struct LastNightCard: View {
    let day: String
    let nightEfficiency: Int
    let nighTotalSleep: Int
    let bedTime: String
    let wakeTime: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Last Night's Efficiency")
                .font(.krungthep(.regular, relativeTo: .body))
                .foregroundStyle(.white)
                .padding(.bottom, 4)
        
            VStack {
                HStack {
                    Text(day)
                        .font(.krungthep(.regular, relativeTo: .body))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Text(nightEfficiency.formatted(.percent))
                        .font(.dsDigital(.bold, size: 96))
                        .foregroundStyle(.accent)
                        .neon()
                        .font(.largeTitle)
                    Text("You slept \(nighTotalSleep) hours")
                        .font(.krungthep(.regular, relativeTo: .body))
                }
                
                Spacer()
                
                HStack {
                    Label(bedTime, systemImage: "moon.zzz.fill")
                    Spacer()
                    Label(wakeTime, systemImage: "sun.max.fill")
                }
                .font(.krungthep(.regular, relativeTo: .callout))
                .foregroundStyle(.secondary)
                .padding()
            }
            .foregroundStyle(.white)
            .frame(width: 340, height: 220)
            .background {
                Rectangle()
                    .stroke(style: .init(lineWidth: 2))
                    .foregroundStyle(.white)
                    .frame(width: 340, height: 220)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        LastNightCard(day: "Monday", nightEfficiency: 75, nighTotalSleep: 4, bedTime: "02.30", wakeTime: "07.00")
    }
    .ignoresSafeArea()
}
