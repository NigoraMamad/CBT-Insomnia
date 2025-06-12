//
//  WeekSummary.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import SwiftUI
import SwiftData

struct WeekSummary: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedWeekStart: Date = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 1 = Sunday, 2 = Monday, 3 = Tuesday, 4 = Wednesday
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let hour = calendar.component(.hour, from: now)
        // If it's before 6 AM, subtract one day
        var fixedDate = Date()
        if hour < 6 {
            fixedDate = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        } else {
            fixedDate = startOfToday
        } // -> if hour < 6
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fixedDate))!
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
                .padding(.bottom, 27.5)
                
                // MARK: SLEEP DATA
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // MARK: SUB-TITLE
                        Text("Avg Sleep EFFICIENCY")
                            .foregroundStyle(.white)
                        
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
                                        .foregroundColor(diffEfficiency < 0 ? .redWarning : .accent)
                                        .font(.krungthep(.regular, relativeTo: .title2))
                                        .frame(width: 7.5, height: 12.5)
                                    Text("\(String(format: "%.2f", diffEfficiency))%")
                                        .font(.krungthep(.regular, relativeTo: .title2))
                                        .foregroundStyle(diffEfficiency < 0 ? .redWarning : .accent)
                                } // -> HStack
                                .shadow(color: diffEfficiency < 0 ? .redWarning.opacity(0.8) : .accent.opacity(0.8), radius: 10, x: 0, y: 0)
                                .shadow(color: diffEfficiency < 0 ? .redWarning.opacity(0.4) : .accent.opacity(0.4), radius: 30, x: 0, y: 0)
                            } // -> if
                            
                        } // -> HStack
                        
                        if !pastSessions.isEmpty {
                            let (hours,mins) = averageSleepHours(sessions: pastSessions)
                            Text("Compared to \(hours)h\(mins < 10 ? "0" : "")\(mins) from last week")
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
                        
                        let session = dayFor(day: day, sessions: weeklySessions)
                        let sleepEfficiency = session?.sleepEfficiency ?? 0.0
                        let completed = session?.isComplete ?? false
                        
                        HStack {
                            
                            Text(day.shortLabel)
                                .foregroundStyle(completed ? colorForSleep(efficiency: sleepEfficiency) : .grayNA)
                                .font(.krungthep(.regular, relativeTo: .title2))
                                .frame(width: 30, alignment: .leading)
                            
                            GeometryReader { geo in
                                let fullWidth = geo.size.width
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.grayNA)
                                    if let sleepEfficiency = session?.sleepEfficiency {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(colorForSleep(efficiency: sleepEfficiency))
                                            .frame(width: sleepEfficiency != 0.0 ? max(10, sleepEfficiency*fullWidth/100) : 0.0)
                                    } // -> if-let
                                } // -> ZStack
                            } // -> GeometryReader
                            .frame(height: 25)
                            if completed {
                                Text("\(Int(sleepEfficiency).formatted(.percent))")
                                    .foregroundStyle(completed ? colorForSleep(efficiency: sleepEfficiency) : .grayNA)
                                    .frame(width: 45, alignment: .trailing)
                            } else {
                                Text("--")
                                    .foregroundStyle(.grayNA)
                                    .frame(width: 45, alignment: .trailing)
                            }
                            
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
        } catch {
            print("Failed to fetch weekly sessions: \(error)")
        } // -> do-catch
        
    } // -> fetchWeekSleepSessions
    
    func averageEfficiency(sessions: [SleepSession]) -> Float {
        var totalCount = sessions.count
        guard totalCount > 0 else { return 0 }
        var totalSum = 0.0
        for session in sessions {
            if !session.isComplete { totalCount -= 1; continue }
            totalSum += session.sleepEfficiency
        } // -> for session in sessions
        return Float(totalSum/Double(totalCount))
    } // -> averageEfficiency
    
    func averageSleepHours(sessions: [SleepSession]) -> (Int,Int) {
        var totalCount = sessions.count
        guard totalCount > 0 else { return (0,0) }
        var totalSeconds: TimeInterval = 0
        for session in sessions {
            if !session.isComplete { totalCount -= 1; continue }
            totalSeconds += session.sleepDuration
        } // -> for session in sessions
        let averageSeconds = totalSeconds / Double(totalCount)
        let averageHours = Int(averageSeconds) / 3600
        let averageMinutes = (Int(averageSeconds) % 3600) / 60
        return (averageHours,averageMinutes)
    } // -> averageSleepHours
    
    func dayFor(day: Days, sessions: [SleepSession]) -> SleepSession? {
        sessions.first { session in
            let weekday = Calendar.current.component(.weekday, from: session.day)
            let weekdayEnum = Days.fromCalendarWeekday(calendarWeekday: weekday)
            return weekdayEnum == day
        } // -> sessions.first
    } // -> dayFor
    
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
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let hour = calendar.component(.hour, from: now)
        // If it's before 6 AM, subtract one day
        var fixedDate = Date()
        if hour < 6 {
            fixedDate = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        } else {
            fixedDate = startOfToday
        } // -> if hour < 6
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fixedDate))!
    } // -> startWeekDate
    
    func colorForSleep(efficiency: Double?) -> Color {
        guard let data = efficiency else {
            return .grayNA
        } // -> guard let data = efficiency
        if data >= 80 {
            return .accent
        } else if data >= 70 {
            return .yelloWarning
        } else {
            return .redWarning
        } // -> if data
    } // -> colorForSleep
    
} // -> SleepSummary

#Preview {
    WeekSummary()
} // -> Preview
