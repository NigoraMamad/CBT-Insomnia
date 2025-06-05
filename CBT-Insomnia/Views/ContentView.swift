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
    
    @AppStorage("userName") private var name: String = ""
    
    
    @State private var isBadgingBedViewShown = false
    @State private var isBadgingWakeViewShown = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.black
                
                VStack {
                    Spacer()
                    
                    
                    Dialogue(
                        mainPlaceholder: dialogueText(for: getMainPHForCurrentTime(), name: name),
                        placeholder: ""
                    )
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
    
    func getMainPHForCurrentTime() -> MainPH {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:
            return .morning
        case 12..<17:
            return .naps
        case 17..<21:
            return .evening
        default:
            return .sleeping
        }
    }
    
    
    func dialogueText(for phase: MainPH, name: String) -> String {
        switch phase {
        case .morning:
            return "GOOD MORNING, \(name.uppercased())!"
        case .naps:
            return "DO NOT TAKE NAPS, \(name.uppercased())!"
        case .evening:
            return "GOOD EVENING, \(name.uppercased())!"
        case .sleeping:
            return "ZZZ"
        }
    }
}


#Preview {
    ContentView()
}
