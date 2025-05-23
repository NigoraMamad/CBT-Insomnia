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
                   // Sfondo arrotondato
                   RoundedRectangle(cornerRadius: 20)
                .fill(   LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 20/255, green: 26/255, blue: 42/255), location: 0),
                        .init(color: Color(red: 69/255, green: 89/255, blue: 144/255), location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                       .overlay(
                           RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 132/255, green: 163/255, blue: 255/255).opacity(0.35), lineWidth: 2)
                           
                       )

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
               .frame(maxWidth: .infinity, maxHeight: 250)
               .padding(.horizontal) // Solo padding laterale
        
           }
       }
    


#Preview {
    BedTimeView()
}
