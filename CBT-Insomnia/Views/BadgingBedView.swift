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
                
                RobotView()
                
                BadgeSleepButton(label: "Start", isActive: true) {
                    
                }
                .font(.krungthep(.regular, relativeTo: .callout))
            }
            .padding()
        }
        .ignoresSafeArea()
        .font(.krungthep(.regular, relativeTo: .title2))
        .foregroundStyle(.white)
    }
}

#Preview {
    BadgingBedView()
}
