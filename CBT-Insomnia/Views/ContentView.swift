//
//  ContentView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 19/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var manager = HealthManager()
    @AppStorage("userName") private var name: String = ""
    @EnvironmentObject private var sleepDataService: SleepDataService
    @Environment(\.modelContext) private var modelContext
    @StateObject private var adjustmentVM: SleepAdjustmentViewModel
    
    init(context: ModelContext) {
        _adjustmentVM = StateObject(wrappedValue: SleepAdjustmentViewModel(context: context))
    }
    
    // From default or fallback
    var wakeTime: String {
        guard let wake = UserDefaultsService.shared.getWakeUpTime() else { return "07:00" }
        let hour = wake.hour ?? 7
        let minute = wake.minute ?? 0
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var bedTime: String {
        guard let bed = getBedTimeFromDefaults() else { return "01:00" }
        let hour = bed.hour ?? 1
        let minute = bed.minute ?? 0
        return String(format: "%02d:%02d", hour, minute)
    }
    
    var lastNightSession: SleepSession? {
        sleepDataService.getRecentSleepSessions(context: modelContext, limit: 1).first
    }
    
    var nightEfficiency: Int {
        guard let session = lastNightSession, session.isComplete else { return 0 }
        return Int(session.sleepEfficiency)
    }
    
    var nightTotalSleep: Int {
        guard let session = lastNightSession, session.isComplete else { return 0 }
        return Int(session.timeInBed / 3600)
    }
    
    var day: String {
        guard let date = lastNightSession?.day else { return "--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    @State private var isBadgingBedViewShown = false
    @State private var isBadgingWakeViewShown = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                VStack {
                    Spacer()
                    Button {
                        manager.fetchAllSleep(modelContext: modelContext)
                    } label: {
                        Dialogue(
                            mainPlaceholder: dialogueText(for: getMainPHForCurrentTime(), name: name),
                            placeholder: ""
                        ).padding(.top, 10)
                    }
                    RobotView()
                    BadgeSleepCard(
                        fixedBedTime: bedTime,
                        fixedWakeTime: wakeTime,
                        onBedTap: { isBadgingBedViewShown = true },
                        onWakeTap: { isBadgingWakeViewShown = true }
                    ).padding()
                    
                    //                    NavigationLink( destination: StatisticsView(
                    //                        bedTime: getBedTimeFromDefaults() ?? DateComponents(hour: 1, minute: 0),
                    //                        wakeTime: UserDefaultsService.shared.getWakeUpTime() ?? DateComponents(hour: 7, minute: 0)
                    //                    ).environmentObject(manager)
                    //                    ) {
                    //                        LastNightCard(day: day, nightEfficiency: nightEfficiency, nighTotalSleep: nightTotalSleep, bedTime: bedTime, wakeTime: wakeTime)
                    //                    } // -> NavigationLink
                    //                    if let session = lastNightSession {
                    //                        NavigationLink(destination: StatisticsView().environmentObject(manager)) {
                    //                            LastNightCard(session: session)
                    //                        }
                    //                    } else {
                    //                        // Show placeholder when no sleep data exists
                    //                        VStack {
                    //                            Text("No Sleep Data")
                    //                                .font(.krungthep(.regular, relativeTo: .title2))
                    //                                .foregroundColor(.gray)
                    //                            Text("Badge in tonight to start tracking")
                    //                                .font(.krungthep(.regular, relativeTo: .body))
                    //                                .foregroundColor(.gray)
                    //                        }
                    //                        .frame(width: 340, height: 240)
                    //                        .background {
                    //                            RoundedRectangle(cornerRadius: 20)
                    //                                .stroke(.gray, lineWidth: 2)
                    //                                .frame(width: 340, height: 240)
                    //                        }
                    //                    }
                    
                    
                    
                    NavigationLink(destination: StatisticsView(
                        bedTime: getBedTimeFromDefaults() ?? DateComponents(hour: 1, minute: 0),
                        wakeTime: UserDefaultsService.shared.getWakeUpTime() ?? DateComponents(hour: 7, minute: 0)
                    )) {
                        if let session = lastNightSession {
                            LastNightCard(session: session)
                        } else {
                            // Show placeholder when no sleep data exists
                            VStack {
                                Text("No Sleep Data")
                                    .font(.krungthep(.regular, relativeTo: .title2))
                                    .foregroundColor(.gray)
                                Text("Badge in tonight to start tracking")
                                    .font(.krungthep(.regular, relativeTo: .body))
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 340, height: 240)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray, lineWidth: 2)
                                    .frame(width: 340, height: 240)
                            }
                        }
                    }
                    
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
        
        .onAppear {
            adjustmentVM.checkIfShouldShowWeeklySummary()
        }
        .sheet(isPresented: $adjustmentVM.showEfficiencySheet) {
            WeeklyEfficiencySheet(viewModel: adjustmentVM)
                .presentationDetents([.medium])
        }
        
    }
    
    
    func getMainPHForCurrentTime() -> MainPH {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return .morning
        case 12..<17: return .naps
        case 17..<21: return .evening
        default: return .sleeping
        }
    }
    
    func dialogueText(for phase: MainPH, name: String) -> String {
        switch phase {
        case .morning: return "GOOD MORNING, \(name.uppercased())!"
        case .naps: return "DO NOT TAKE NAPS, \(name.uppercased())!"
        case .evening: return "GOOD EVENING, \(name.uppercased())!"
        case .sleeping: return "ZZZ"
        }
    }
}



func getBedTimeFromDefaults() -> DateComponents? {
    guard
        let wakeUpTime = UserDefaultsService.shared.getWakeUpTime(),
        let sleepDuration = UserDefaultsService.shared.getSleepDuration()
    else {
        return nil
    }
    
    
    let duration = sleepDuration.dateComponents
    let offset = UserDefaultsService.shared.getBedTimeOffset() ?? DateComponents()
    
    let totalDuration = Calendar.current.date(byAdding: offset, to: Calendar.current.date(from: duration)!)!
    let totalComponents = Calendar.current.dateComponents([.hour, .minute], from: totalDuration)
    
    let wakeHour = wakeUpTime.hour ?? 7
    let wakeMinute = wakeUpTime.minute ?? 0
    let durationHour = sleepDuration.dateComponents.hour ?? 6
    let durationMinute = sleepDuration.dateComponents.minute ?? 0
    
    var calendar = Calendar.current
    calendar.timeZone = .current
    
    var wakeComponents = calendar.dateComponents([.year, .month, .day], from: Date())
    wakeComponents.hour = wakeHour
    wakeComponents.minute = wakeMinute
    
    guard let wakeDate = calendar.date(from: wakeComponents) else { return nil }
    
    let totalMinutes = -(totalComponents.hour ?? 0) * 60 - (totalComponents.minute ?? 0)
    let bedDate = calendar.date(byAdding: .minute, value: totalMinutes, to: wakeDate)!
    
    let bedTimeComponents = calendar.dateComponents([.hour, .minute], from: bedDate)
    
    return calendar.dateComponents([.hour, .minute], from: bedDate)
}

//#Preview {
//    // Mock SleepDataService con dati finti
//    class MockSleepDataService: SleepDataService {
//        override func getRecentSleepSessions(limit: Int = 7) -> [SleepSession] {
//            let now = Date()
//            let earlier = Calendar.current.date(byAdding: .hour, value: -7, to: now)!
//            let session = SleepSession(
//                nightDate: Calendar.current.date(byAdding: .day, value: -1, to: now)!,
//                badgeInTime: earlier,
//                badgeOutTime: now,
//                sleepDuration: 6 * 3600 // 6 ore
//            )
//            return [session]
//        }
//    }
//
//    // Mock HealthManager se richiesto da StatisticsView
//    struct MockStatisticsView: View {
//        var body: some View {
//            Text("Statistics")
//        }
//    }
//
//    // Estensione temporanea per iniettare la dipendenza
//    struct PreviewContentView: View {
//        var body: some View {
//            ContentView()
//                .environmentObject(MockSleepDataService())
//        }
//    }
//
//    return PreviewContentView()
//}

