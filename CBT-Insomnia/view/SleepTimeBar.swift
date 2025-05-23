//
//  SleepTimeBar.swift
//  CBT-Insomnia
//
//  Created by Gianpietro Panico on 22/05/25.
//

import Foundation
import SwiftUI


struct SleepTimeBar: View {
    
    @State var startSleep = "22:00"
    @State var endSleep = "07:00"
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                
                Text("\(startSleep)")
                        .foregroundColor(.white)
                        .font(.system(size: 14).bold())
                        //.padding(.horizontal, 4)
                        .frame(maxWidth: .infinity)
                }
        
            
            // Barra di sfondo + barra attiva
            ZStack(alignment: .leading) {
                
                // Rettangolo blu di sfondo
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(red: 19/255, green: 24/255, blue: 63/255))
                    .frame(height: 50)

                // Dati temporanei per test visivo
                let blocchiTotali = 10
                let larghezzaTotale: CGFloat = 300
                let larghezzaPerOra = larghezzaTotale / CGFloat(blocchiTotali)
                let oreDormite = 6

                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "FF904F"), location: 0),
                                .init(color: Color(hex: "B24708"), location: 0.44)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: larghezzaPerOra * CGFloat(oreDormite) - 6, height: 40)
                    .padding(.leading, 6)
            }
          
        }
        .padding()
       
        
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}


struct ContentView: View {
    var body: some View {
        
        ZStack {
            LinearGradient(
                  gradient: Gradient(colors: [
                      Color(red: 20/255, green: 26/255, blue: 42/255),
                      Color(red: 69/255, green: 89/255, blue: 144/255)
                  ]),
                  startPoint: .top,
                  endPoint: .bottom
              )
             .ignoresSafeArea()
            SleepTimeBar()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

