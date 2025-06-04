//
//  BadgingBedView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI

struct BadgingBedView: View {
    @State private var isTrackingBedShown: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .fullScreenCover(isPresented: $isTrackingBedShown) {
                TrackingBedView()
            }
        }
        .ignoresSafeArea()
        .font(.krungthep(.regular, relativeTo: .title2))
        .foregroundStyle(.white)
    }
}

#Preview {
    BadgingBedView()
}
