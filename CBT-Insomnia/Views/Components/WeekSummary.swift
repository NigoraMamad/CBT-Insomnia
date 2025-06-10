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
    
    @State private var selectedWeekStart: Date = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 1 = Sunday, 2 = Monday, 3 = Tuesday, 4 = Wednesday
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }() // -> selectedWeekStart
    
    @State private var weeklySessions: [SleepSession] = []
    @State private var pastSessions: [SleepSession] = []
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack(alignment: .center) {
                
                // MARK: STEPS TEXT
                HStack {
                    Spacer()
                    Button {
                        selectedWeekStart = Calendar.current.date(byAdding: .day, value: -7, to: selectedWeekStart)!
                        fetchWeekSleepSessions(weekStart: selectedWeekStart)
                        fetchPastWeekSleepSessions(pastWeekEnd: selectedWeekStart)
                    } label: {
                        Image(systemName: "chevron.backward")
                    } // -> Button
                    Spacer()
                    Text(currentWeekLabel(date: selectedWeekStart))
                    Spacer()
                    Button {
                        if selectedWeekStart < startWeekDate() {
                            selectedWeekStart = Calendar.current.date(byAdding: .day, value: 7, to: selectedWeekStart)!
                            fetchWeekSleepSessions(weekStart: selectedWeekStart)
                            fetchPastWeekSleepSessions(pastWeekEnd: selectedWeekStart)
                        }
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
                            
                            let currEfficiency = averageEfficiency(sessions: weeklySessions)
                            
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
                            Text("Compared to \(pastSleepComponent.hour ?? 7)h\(pastSleepComponent.minute ?? 0 < 10 ? "0" : "")\(pastSleepComponent.minute ?? 0) from last week")
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
                    
                    ForEach(days, id: \.self) { day in
                        
                        let session = manager.dayFor(day: day, sessions: weeklySessions)
                        
                        HStack {
                            
                            Text(day.shortLabel)
                                .foregroundStyle(.white)
                                .font(.krungthep(.regular, relativeTo: .title2))
                                .frame(width: 30, alignment: .leading)
                            
                            GeometryReader { geo in
                                let fullWidth = geo.size.width
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.tertiary)
                                    if let sleepEfficiency = session?.sleepEfficiency {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.accent)
                                            .frame(width: sleepEfficiency != 0.0 ? max(10, sleepEfficiency*fullWidth/100) : 0.0)
                                            .shadow(color: .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                                    } // -> if-let
                                } // -> ZStack
                            } // -> GeometryReader
                            .frame(height: 30)
                            
                            Text("\(String(format: "%.0f", session?.sleepEfficiency ?? 0.0))%")
                                .foregroundStyle(.white)
                                .frame(width: 45, alignment: .trailing)
                            
                        } // -> HStack
                        
                        if day != days[days.count-1] {
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
        .onAppear {
            fetchWeekSleepSessions(weekStart: selectedWeekStart)
            fetchPastWeekSleepSessions(pastWeekEnd: selectedWeekStart)
        }
        
    } // -> body
    
    func fetchWeekSleepSessions(weekStart: Date) {
        let calendar = Calendar.current
        guard let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { return }
        
        // Current week
        let predicate = #Predicate<SleepSession> {
            $0.day >= weekStart && $0.day < weekEnd
        } // -> predicate

        let descriptor = FetchDescriptor<SleepSession>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.day)]
        ) // -> descriptor
        
        do {
            weeklySessions = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch weekly sessions: \(error)")
        } // -> do-catch
        
    } // -> fetchWeekSleepSessions
    
    func fetchPastWeekSleepSessions(pastWeekEnd: Date) {
        let calendar = Calendar.current
        guard let pastWeekStart = calendar.date(byAdding: .day, value: -7, to: pastWeekEnd) else { return }
        print(pastWeekStart)
        print(pastWeekEnd)
        
        // Past week
        let predicate = #Predicate<SleepSession> {
            $0.day >= pastWeekStart && $0.day < pastWeekEnd
        } // -> predicate

        let descriptor = FetchDescriptor<SleepSession>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.day)]
        ) // -> descriptor

        do {
            pastSessions = try context.fetch(descriptor)
            for session in pastSessions {
                print(session.day)
            }
        } catch {
            print("Failed to fetch weekly sessions: \(error)")
        } // -> do-catch
        
    } // -> fetchWeekSleepSessions
    
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
    
    func currentWeekLabel(date: Date) -> String {
        let calendar = Calendar.current
        
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: date)!

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        let startString = formatter.string(from: date)
        let endString = formatter.string(from: endOfWeek)

        return "\(startString) - \(endString)"
    } // -> currentWeekLabel
    
    func startWeekDate() -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 1 = Sunday, 2 = Monday, 3 = Tuesday, 4 = Wednesday
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    } // -> startWeekDate
    
} // -> SleepSummary

#Preview {
    @Previewable @State var manager = HealthManager()
    WeekSummary()
        .environmentObject(manager)
} // -> Preview
