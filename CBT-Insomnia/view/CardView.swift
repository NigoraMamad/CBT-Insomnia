//
//  CardView.swift
//  CBT-Insomnia
//
//  Created by Michele Coppola on 22/05/25.
//

import SwiftUI

struct CardView: View {
    var height: CGFloat
    
    var body: some View {
       
            
            RoundedRectangle(cornerRadius: 30)
                .frame(height: height)
                .padding()
                .foregroundStyle(.ultraThinMaterial.opacity(0.75))
        }
        
    
}

#Preview {
    CardView(height: 400)
        .ignoresSafeArea()
}
