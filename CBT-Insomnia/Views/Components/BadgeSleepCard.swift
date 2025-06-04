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
    var onWakeTap: (() -> Void)? = nil
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
                    label: "In Bed",
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
                                label: "Awake",
                                isActive: activeButton == .wake
                            ) {
                                activeButton = .bed
                                onWakeTap?()  // 🔗 Trigger navigation
                            }
                        }
                        .padding()
        }
        .foregroundStyle(.white)
        .font(.krungthep(.regular, relativeTo: .callout))
        .frame(width: 340, height: 136)
    }
}

#Preview {
    ZStack {
        Color(.black)
        BadgeSleepCard(fixedBedTime: "02.00", fixedWakeTime: "07.00")
    }
    .ignoresSafeArea()
}
