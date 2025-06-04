//
//  BadgingBedView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI

struct BadgingBedView: View {
    @State private var isTrackingBedShown: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Text("Lay down in bed and wait for me to start tracking your sleep!")
                
                RobotView()
                
                BadgeSleepButton(label: "Start", isActive: true) {
                    isTrackingBedShown = true
                }
                .font(.krungthep(.regular, relativeTo: .callout))
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isTrackingBedShown) {
            TrackingBedView()
        }
        .ignoresSafeArea()
        .font(.krungthep(.regular, relativeTo: .title2))
        .foregroundStyle(.white)
    }
}

#Preview {
    BadgingBedView()
}
