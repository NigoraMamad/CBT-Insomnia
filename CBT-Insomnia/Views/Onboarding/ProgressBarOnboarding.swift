//
//  ProgressBarOnboarding.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 30/05/25.
//

import SwiftUI

import SwiftUI

struct ProgressBarOnboarding: View {
    
    /// value  0.0 (0%) and 1.0 (100%)
    var progress: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            
            // Background
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 15)

            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.accent)
                    .frame(width: geometry.size.width * progress, height: 15)
            }
            .frame(height: 15)
        }
        .frame(width: 268, height: 15) //larghezza barra
    }
}


#Preview {
    ProgressBarOnboarding(progress: 0.5)
}
