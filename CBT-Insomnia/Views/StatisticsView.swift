//
//  StatisticsView.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 19/05/25.
//

import SwiftUI

struct StatisticsView: View {
    
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .center) {
                
                ScrollView {
                    
                    // MARK: DIALOG BUBBLE
                    Dialogue(
                        mainPlaceholder:"GOOD MORNING, DIMA!",
                        placeholder: "THIS IS YOUR LAST NIGHT REPORT.\nIT’S LOOKING GOOD!"
                    ) // -> Dialogue
                        .padding(.top, 10)
                    
                    // MARK: AVATAR
                    Image(.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.bottom, 50)
                    
                    // MARK: STEPS TEXT
                    HStack {
                        Text("TAP")
                            .foregroundStyle(.white)
                        Text("SORTIE")
                            .foregroundStyle(.accent)
                        Text("TO FOLLOW MORE STEPS")
                            .foregroundStyle(.white)
                    } // -> HStack
                    .font(.system(size: 20))
                    .padding(.bottom, 20)
                    
                    // MARK: SLEEP SUMMARY
                    SleepSummary()
                        .environmentObject(manager)
                    
                } // -> ScrollView
                .scrollIndicators(.hidden)
                
            } // -> VStack
            .padding(.horizontal)
            
        } // -> ZStack
        // MARK: BG COLOR
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
    } // -> body
    
} // -> HomeView

#Preview {
    StatisticsView()
} // -> Preview
