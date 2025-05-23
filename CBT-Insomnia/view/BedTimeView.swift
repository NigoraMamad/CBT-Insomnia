//
//  BedTimeView.swift
//  CBT-Insomnia
//
//  Created by Gianpietro Panico on 22/05/25.
//

import SwiftUI


struct BedTimeView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                // Titolo con icona
                HStack {
                    
                    Image(systemName: "bed.double.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    Text("Bedtime Window")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                }
                
                Spacer()
                    .frame(height: 1)
                
                
                SleepTimeBar()
                
                
                let textSize: CGFloat = 16
                
                VStack(alignment: .leading, spacing: 4) {
                    (
                        Text("You should go to sleep within this ")
                            .foregroundColor(.white)
                            .font(.system(size: textSize))
                        +
                        Text("window.")
                            .foregroundColor(Color(red: 231/255, green: 121/255, blue: 58/255)) // #6466F1
                            .font(.system(size: textSize))
                    )
                    
                    Text("Keep going, rest is progress.")
                        .foregroundColor(.white)
                        .font(.system(size: textSize))
                }
            }
            .padding()
        }
        .padding()
        .background( RoundedRectangle(cornerRadius: 30)
            .foregroundStyle(.ultraThinMaterial.opacity(0.75))
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(LinearGradient(colors: [.white, .black, .black, .white, .white], startPoint: .bottomTrailing, endPoint: .leading))
            }
            .padding()
            .shadow(radius: 4, x: 4, y: 4))
        .foregroundStyle(.white)
        .ignoresSafeArea()
        
    }
}



#Preview {
    BedTimeView()
}
