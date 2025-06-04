//
//  BadgeSleepButton.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 01/06/25.
//

import SwiftUI

struct BadgeSleepButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .padding()
                .foregroundStyle(isActive ? .black : .gray)
                .frame(width: 140, height: 54)
                .background {
                    if isActive {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.accent)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                    }
                }
        }
        .disabled(!isActive)
    }
}

#Preview {
    ZStack {
        Color.black
        VStack {
            BadgeSleepButton(label: "I'm going to sleep", isActive: true, action: {})
            BadgeSleepButton(label: "I'm awake", isActive: false, action: {})
        }
    }
    .ignoresSafeArea()
}
