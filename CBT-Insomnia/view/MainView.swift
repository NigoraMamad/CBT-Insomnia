//
//  ContentView.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                MeshGradientBg().ignoresSafeArea()
                VStack{
                    HStack{
                        Circle()
                            .fill(Color.white)
                            .frame(width: 43, height: 43)
                            .padding()
                        Text("Hi,")
                        Text("Dario") //this name should be taken from the filled form in the onboarding
                        Spacer()
                        Button(action: {/*open info*/}) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                    }
                    .padding()
                    
                    NavigationLink(destination: BedWindowView()) {
                       BedTimeComp()
                    }
                    
                    NavigationLink(destination: NightStatsView()) {
                        LastNightCardView()
                    }
                    
                    
                }
                
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    MainView()
}
