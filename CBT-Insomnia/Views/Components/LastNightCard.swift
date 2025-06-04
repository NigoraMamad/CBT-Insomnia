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
            HStack {
                Text("Last Night's")
                    .font(.krungthep(.regular, relativeTo: .body))
                    .foregroundStyle(.white)
                    .padding(.bottom, 4)
                Text("Efficiency")
                    .font(.krungthep(.regular, relativeTo: .body))
                    .foregroundStyle(.accent)
                    .padding(.bottom, 4)
            }
        
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
                .padding()
            }
            .foregroundStyle(.black)
            .frame(width: 340, height: 240)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
                    .frame(width: 340, height: 240)
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
