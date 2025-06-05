//
//  ContentView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 19/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var manager = HealthManager()
    
    let fixedBedTime: String = "02:00"
    let fixedWakeTime: String = "07:00"
    let day: String = "Monday"
    let nightEfficiency: Int = 80
    let nightTotalSleep: Int = 4
    let bedTime: String = "02:20"
    let wakeTime: String = "07:10"
    
    @State private var isBadgingBedViewShown = false
    @State private var isBadgingWakeViewShown = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.black
                
                VStack {
                    Spacer()
                    
                    Dialogue(
                        mainPlaceholder:"GOOD MORNING!",
                        placeholder: ""
                    ) // -> Dialogue
                        .padding(.top, 10)
                    
                    RobotView()
                    BadgeSleepCard(
                        fixedBedTime: fixedBedTime,
                        fixedWakeTime: fixedWakeTime,
                        onBedTap: {
                            isBadgingBedViewShown = true
                        },
                        onWakeTap: {
                            isBadgingWakeViewShown = true
                        }
                    )
                    .padding()
                    
                    NavigationLink(destination: StatisticsView().environmentObject(manager)) {
                        LastNightCard(day: day, nightEfficiency: nightEfficiency, nighTotalSleep: nightTotalSleep, bedTime: bedTime, wakeTime: wakeTime)
                    } // -> NavigationLink
                    
                    Spacer()
                }
                
            }
            .fullScreenCover(isPresented: $isBadgingBedViewShown) {
                BadgingBedView()
            }
            .fullScreenCover(isPresented: $isBadgingWakeViewShown) {
                BadgingWakeView()
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
