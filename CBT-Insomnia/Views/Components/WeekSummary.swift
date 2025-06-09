//
//  WeekSummary.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import SwiftUI
import SwiftData

struct WeekSummary: View {
    
    @EnvironmentObject var manager: HealthManager
    
    @Environment(\.modelContext) private var context
    @Query(
        filter: SleepSession.currentWeek(),
        sort: \SleepSession.day
    ) var sessions: [SleepSession]
    @Query(
        filter: SleepSession.previousWeek(),
        sort: \SleepSession.day
    ) var pastSessions: [SleepSession]
    
    @State private var selectedPeriod: Period = .day
    
    var efficiency = 0.0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack(alignment: .center) {
                
                // MARK: STEPS TEXT
                HStack {
                    Spacer()
                    Button {
                        //
                    } label: {
                        Image(systemName: "chevron.backward")
                    } // -> Button
                    Spacer()
                    Text(currentWeekLabel())
                    Spacer()
                    Button {
                        //
                    } label: {
                        Image(systemName: "chevron.forward")
                    } // -> Button
                    Spacer()
                } // -> HStack
                .foregroundStyle(.white)
                .padding(.bottom, 20)
                
                // MARK: SLEEP DATA
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // MARK: SUB-TITLE
                        Text("AVG SLEEP EFFICIENCY")
                            .foregroundStyle(.white)
                            .padding(.top, 20)
                        
                        // MARK: SLEEP EFF SUMMARY
                        HStack(alignment: .bottom, spacing: 15) {
                            
                            let currEfficiency = averageEfficiency(sessions: sessions)
                            
                            Text("\(String(format: "%.2f", currEfficiency))%")
                                .foregroundStyle(.white)
                                .font(.dsDigital(.bold, relativeTo: .largeTitle))
                            
                            if !pastSessions.isEmpty {
                                
                                let pastEfficiency = averageEfficiency(sessions: pastSessions)
                                let diffEfficiency = currEfficiency - pastEfficiency
                                
                                HStack(spacing: 2) {
                                    Image(systemName: diffEfficiency < 0 ? "arrow.down" : "arrow.up")
                                        .resizable()
                                        .foregroundColor(.accent)
                                        .font(.krungthep(.regular, relativeTo: .title2))
                                        .frame(width: 7.5, height: 12.5)
                                    Text("\(String(format: "%.2f", diffEfficiency))%")
                                        .font(.krungthep(.regular, relativeTo: .title2))
                                        .foregroundStyle(.accent)
                                } // -> HStack
                                .shadow(color: .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                                .shadow(color: .accent.opacity(0.4), radius: 30, x: 0, y: 0)
                            } // -> if
                            
                        } // -> HStack
                        
                        if !pastSessions.isEmpty {
                            let pastSleepComponent = averageSleepHours(sessions: pastSessions)
                            Text("Compared to \(String(describing: pastSleepComponent.hour))h\(String(describing: pastSleepComponent.minute)) from last week")
                                .foregroundStyle(.gray)
                        } // -> if
                        
                    } // -> VStack
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: SHINEE ICON
                    SparkleIcon()
                        .frame(width: 25, height: 25)
                    
                } // -> HStack
                .padding(.bottom, 20)
                
                // MARK: TABLE/CHARTS
                VStack(spacing: 20) {
                    
                    let days = Days.allCases
                    
                    ForEach(sessions.sorted { $0.day < $1.day }, id: \.self) { session in
                        
                        let dayLabel = manager.dateFor(date: session.day)
                        
                        HStack {
                            
                            Text(dayLabel.shortLabel)
                                .foregroundStyle(.white)
                                .font(.krungthep(.regular, relativeTo: .title2))
                                .frame(width: 30, alignment: .leading)
                            
                            GeometryReader { geo in
                                let fullWidth = geo.size.width
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.secondary)
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.accent)
                                        .frame(width: session.sleepEfficiency != 0.0 ? max(10, session.sleepEfficiency*fullWidth/100) : 0.0)
                                        .shadow(color: .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                                } // -> ZStack
                            } // -> GeometryReader
                            .frame(height: 30)
                            
                            Text("\(String(format: "%.0f", session.sleepEfficiency))%")
                                .foregroundStyle(.white)
                                .frame(width: 45, alignment: .trailing)
                            
                        } // -> HStack
                        
                        if dayLabel != days[days.count-1] {
                            Divider()
                                .frame(minHeight: 1)
                                .background(.gray.opacity(0.3))
                        } // -> if
                        
                    } // -> ForEach
                    
                } // -> VStack
                
                Spacer()
                
            } // -> VStack
            
        } // -> ZStack
        // MARK: BG COLOR
        .preferredColorScheme(.dark)
        .navigationTitle("STATISTICS")
        
    } // -> body
    
    func averageEfficiency(sessions: [SleepSession]) -> Float {
        let totalCount = sessions.count
        var totalSum = 0.0
        for session in sessions {
            totalSum += session.sleepEfficiency
        } // -> for session in sessions
        guard totalCount > 0 else { return 0 }
        return Float(totalSum/Double(totalCount))
    } // -> averageEfficiency
    
    func averageSleepHours(sessions: [SleepSession]) -> DateComponents {
        let totalCount = sessions.count
        var totalSeconds: TimeInterval = 0
        for session in sessions {
            totalSeconds += session.sleepDuration
        } // -> for session in sessions
        let averageSeconds = totalSeconds / Double(totalCount)
        let averageHours = Int(averageSeconds) / 3600
        let averageMinutes = (Int(averageSeconds) % 3600) / 60
        return DateComponents(hour: averageHours, minute: averageMinutes)
    } // -> averageSleepHours
    
    func currentWeekLabel() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let weekday = calendar.component(.weekday, from: now)
        let daysSinceTuesday = (weekday + 4) % 7 // Tuesday = 0
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceTuesday, to: calendar.startOfDay(for: now))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        let startString = formatter.string(from: startOfWeek)
        let endString = formatter.string(from: endOfWeek)

        return "Week 1: \(startString) - \(endString)"
    }
    
} // -> SleepSummary

#Preview {
    @Previewable @State var manager = HealthManager()
    WeekSummary()
        .environmentObject(manager)
} // -> Preview
