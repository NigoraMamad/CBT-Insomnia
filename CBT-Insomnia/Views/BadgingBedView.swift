//
//  BadgingBedView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI

struct BadgingBedView: View {
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("Lay down in bed and wait for me to start tracking your sleep!")
                    .kerning(2)
                
                RobotView()
                
                BadgeSleepButton(label: "Start tracking", isActive: true) {
                    
                }
                .font(.dsDigital(.regular, relativeTo: .callout))
            }
            .padding()
        }
        .ignoresSafeArea()
        .font(.dsDigital(.regular, relativeTo: .title))
        .foregroundStyle(.white)
    }
}

#Preview {
    BadgingBedView()
}
