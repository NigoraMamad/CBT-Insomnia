//
//  TrackingBedView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI

struct TrackingBedView: View {
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Image(systemName: "bed.double.fill")
                    .foregroundStyle(.accent)
                    .neon(glowRadius: 2.5)
                    .font(.system(size: 65))
                
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    TrackingBedView()
}
