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
            .foregroundStyle(.ultraThinMaterial.opacity(0.75))
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(LinearGradient(colors: [.white, .black, .black], startPoint: .center, endPoint: .leading))
            }
            .padding()
    }
}

#Preview {
    ZStack {
        MeshGradientBg()
        CardView(height: 400)
            .ignoresSafeArea()
    }
}
