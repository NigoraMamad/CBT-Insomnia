//
//  LastNightCard.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 30/05/25.
//

import SwiftUI

struct LastNightCard: View {
    let session: SleepSession
    
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
                    Text(session.formattedNightDate)
                        .font(.krungthep(.regular, relativeTo: .body))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding()
                
                Spacer()
                
                VStack {
                    if session.isComplete {
                        Text(Int(session.sleepEfficiency).formatted(.percent))
                            .font(.dsDigital(.bold, size: 96))
                        Text("You slept \(Int(session.timeInBed / 3600)) hours")
                            .font(.krungthep(.regular, relativeTo: .body))
                    } else {
                        Text("In Progress")
                            .font(.krungthep(.regular, size: 48))
                            .foregroundColor(.orange)
                        Text("Sleep session not completed")
                            .font(.krungthep(.regular, relativeTo: .body))
                    }
                }
                
                Spacer()
                
                HStack {
                    Label(session.formattedBadgeInTime, systemImage: "moon.zzz.fill")
                    Spacer()
                    Label(session.formattedBadgeOutTime, systemImage: "sun.max.fill")
                        .foregroundColor(session.isComplete ? .primary : .secondary)
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
    let now = Date()
    let earlier = Calendar.current.date(byAdding: .hour, value: -6, to: now)!
    let session = SleepSession(
        nightDate: Calendar.current.date(byAdding: .day, value: -1, to: now)!,
        badgeInTime: earlier,
        badgeOutTime: now,
        sleepDuration: 5 * 3600
    )
    
    ZStack {
        Color.black
        LastNightCard(session: session)
    }
    .ignoresSafeArea()
}

