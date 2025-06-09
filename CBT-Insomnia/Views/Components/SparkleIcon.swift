//
//  SparkleIcon.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import SwiftUI

struct SparkleIcon: View {
    
    var body: some View {
        
        GeometryReader { geo in
            Image(.starIcon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.accent)
                .padding(geo.size.width/4)
                .shadow(color: Color.accent.opacity(0.8), radius: 10, x: 0, y: 0)
                .shadow(color: Color.accent.opacity(0.6), radius: 30, x: 0, y: 0)
                .shadow(color: Color.accent.opacity(0.2), radius: 50, x: 0, y: 0)
                .background(
                    Circle()
                        .fill(.accentShineeBg)
                ) // -> Image.background
        } // -> GeometryReader
        
    } // -> body
    
} // -> SparkleIcon

#Preview {
    SparkleIcon()
} // -> Preview
