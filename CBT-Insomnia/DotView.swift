//
//  DotView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 27/05/25.
//


import SwiftUI

struct DotView: View {
    var delay: Double
    @State private var animate = false

    var body: some View {
        Circle()
            .frame(width: 10, height: 10)
            .foregroundColor(animate ? .blue : .gray)
            .animation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever()
                    .delay(delay),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}
