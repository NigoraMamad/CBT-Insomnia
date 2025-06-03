//
//  Dialogue.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 30/05/25.
//

import SwiftUI

struct Dialogue: View {
    
    var mainPlaceholder: String
    var placeholder: String
    
    var body: some View {
        
        VStack {
            
            Text(mainPlaceholder)
                .foregroundStyle(.black)
                .font(.system(size: 20, weight: .bold))
            Text(placeholder)
                .foregroundStyle(.gray)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
            
        } // -> VStack
        .padding()
        .padding(.bottom, 20)
        .background(.white)
        .clipShape(SpeechBubble(tailSize: 20))
        
    } // -> body
    
} // -> Dialogue

#Preview {
    Dialogue(mainPlaceholder: "GOOD MORNING, DIMA!", placeholder: "THIS IS YOUR LAST NIGHT REPORT.\nIT’S LOOKING GOOD!")
} // -> Preview
