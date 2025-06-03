//
//  NeonEffect.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 01/06/25.
//

import SwiftUI

extension View {
    func neon(color: Color = .accent, glowRadius: CGFloat = 7.5) -> some View {
        self
            .foregroundStyle(color)
            .shadow(color: color.opacity(0.5), radius: glowRadius)
            .shadow(color: color.opacity(0.2), radius: glowRadius * 0.66)
            .shadow(color: color.opacity(0.1), radius: glowRadius * 0.33)
            .blur(radius: 0.6)
    }
}
