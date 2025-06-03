//
//  MeshGradientBg.swift
//  CBT-Insomnia
//
//  Created by Michele Coppola on 23/05/25.
//

import SwiftUI

struct MeshGradientBg: View {
    @State private var appear = false
    
    let bgColor = Color(red: 0.19, green: 0.24, blue: 0.63)
    let bgColor2 = Color(red: 0.052, green: 0.071, blue: 0.221)
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [.init(0, 0), .init(0.5, 0), .init(1, 0),
                     .init(0, 0.5), appear ? .init(0.5, 0.5) : .init(0.3, 0.3), appear ? .init(1, 0.5) : .init(1, 0.2),
                     .init(0, 1), .init(0.5, 1), .init(1, 1)
            ],
            colors: [bgColor, bgColor2, bgColor,
                     bgColor, bgColor, bgColor2,
                     bgColor, bgColor2, bgColor2]
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                appear.toggle()
            }
        }
    }
}

#Preview {
    MeshGradientBg()
        .ignoresSafeArea()
}
