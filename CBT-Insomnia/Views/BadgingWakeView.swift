//
//  BadgingWakeView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI

struct BadgingWakeView: View {
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("Hi there! I see you just woke up! Let's take some steps together to start your day.")
                
                RobotView()
                
                BadgeSleepButton(label: "Start Tracking", isActive: true) {
                    
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
    BadgingWakeView()
}
