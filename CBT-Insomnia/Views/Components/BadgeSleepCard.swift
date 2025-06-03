//
//  BadgeSleepCard.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 01/06/25.
//

import SwiftUI

struct BadgeSleepCard: View {
    let fixedBedTime: String
    let fixedWakeTime: String
    
    @State private var activeButton: SleepButtonType? = .bed
    
    enum SleepButtonType {
        case bed, wake
    }
    
    var body: some View {
        HStack {
            VStack() {
                Label(fixedBedTime, systemImage: "moon.zzz.fill")
                Spacer()
                BadgeSleepButton(
                    label: "I'm going to bed",
                    isActive: activeButton == .bed
                ) {
                    activeButton = .wake
                }
            }
            .padding()
            
            VStack {
                Label(fixedWakeTime, systemImage: "sun.max.fill")
                Spacer()
                BadgeSleepButton(
                    label: "I'm awake",
                    isActive: activeButton == .wake
                ) {
                    activeButton = .bed
                }
            }
            .padding()
        }
        .foregroundStyle(.white)
        .font(.dsDigital(.regular, relativeTo: .callout))
        .frame(width: 340, height: 134)
        .background {
            Rectangle()
                .stroke(style: .init(lineWidth: 2))
                .foregroundStyle(.white)
                .frame(width: 340, height: 134)
        }
    }
}

#Preview {
    ZStack {
        Color(.black)
        BadgeSleepCard(fixedBedTime: "02.00", fixedWakeTime: "07.00")
    }
    .ignoresSafeArea()
}
