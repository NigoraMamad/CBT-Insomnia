//
//  DaySummary.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 06/06/25.
//

import SwiftUI
import SwiftData

struct DaySummary: View {
    
    @Environment(\.modelContext) private var context
    
    @State private var selectedDate: Date = {
        let now = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let hour = calendar.component(.hour, from: now)
        // If it's before 6 AM, subtract one day
        if hour < 6 {
            return calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        } else {
            return startOfToday
        } // -> if hour < 6
    }() // -> selectedDate
    
    @State private var currSession: [SleepSession] = []
    
    private let defaults = UserDefaultsService()
    
    var body: some View {
        
        VStack {
            
            // MARK: STEPS TEXT
            HStack {
                Spacer()
                Button {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                    fetchSleepSessions(date: selectedDate)
                } label: {
                    Image(systemName: "chevron.backward")
                } // -> Button
                Spacer()
                Text(currentDayLabel(date: selectedDate))
                Spacer()
                Button {
                    if selectedDate < fixedCurrentDate() {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                        fetchSleepSessions(date: selectedDate)
                    } // -> if selectedDate
                } label: {
                    Image(systemName: "chevron.forward")
                } // -> Button
                Spacer()
            } // -> HStack
            .foregroundStyle(.white)
            
             // MARK: PERCENT
            let completeSession = currSession.first?.isComplete ?? false
            let sleepEfficiency = currSession.first?.sleepEfficiency ?? nil
            let color = colorForSleep(efficiency: sleepEfficiency, isCompleted: completeSession)
            Text("\(!completeSession ? "NA" : Int(sleepEfficiency!).formatted(.percent))")
                .font(.dsDigital(.bold, size: 143))
                .foregroundStyle(color)
                .shadow(color: color.opacity(!completeSession ? 0.0 : 0.6), radius: 10, x: 0, y: 0)
                .shadow(color: color.opacity(!completeSession ? 0.0 : 0.4), radius: 30, x: 0, y: 0)
                .padding(.top, 1)
                .padding(.bottom, -20)
            Text("Efficiency")
                .foregroundStyle(.white)
                .padding(.bottom, 30)
            
            // MARK: HOURS SLEPT VS GOAL SLEEP HOURS
            if let session = currSession.first {
                if !completeSession {
                    Text("Sleep session in progress...")
                        .foregroundStyle(.grayLabel)
                } else {
                    let (sleepHour,sleepMin) = sleepDurationComponent(seconds: session.sleepDuration)
                    let (windowSleepHour,windowSleepMin) = sleepDurationComponent(seconds: session.timeInBed)
                    Text("You slept ")
                        .foregroundStyle(.grayLabel)
                    + Text("\(sleepHour):\(sleepMin < 10 ? "0" : "")\(sleepMin)")
                        .foregroundStyle(color)
                    + Text(" out of \(windowSleepHour):\(windowSleepMin < 10 ? "0" : "")\(windowSleepMin)")
                        .foregroundStyle(.grayLabel)
                } // -> if !completeSession
            } else {
                Text("No data available for this day")
                    .foregroundStyle(.grayLabel)
            } // -> if !currSession.isEmpty
                
            // MARK: PROGRESS BARR
            GeometryReader { geo in
                let fullWidth = geo.size.width
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.grayNA)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: sleepEfficiency == nil ? 0 : sleepEfficiency != 0 ? max(20, sleepEfficiency!*fullWidth/100) : 0)
                } // -> ZStack
            } // -> GeometryReader
            .frame(height: 20)
            .padding(.bottom, 20)
            
            Divider()
                .frame(minHeight: 1)
                .background(.white)
                .padding(.bottom, 20)
            
            // MARK: SLEEP INSIGHTS
            ForEach(SleepStages.allCases, id: \.self) { stage in
                
                let stageDuration = currSession.first?.duration(stage: stage) ?? nil
                let sleepDuration = currSession.first?.sleepDuration ?? nil
                
                HStack(spacing: 20) {
                    Image(systemName: stage.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 30, minHeight: 20, maxHeight: 25)
                        .foregroundStyle(.white)
                    VStack(alignment: .leading) {
                        Text(stage.rawValue)
                            .foregroundStyle(color)
                        Text((stageDuration != nil && sleepDuration != nil && sleepDuration! > 0) ? "\(String(format: "%.0f", (stageDuration!/sleepDuration!)*100))%" : "--")
                            .foregroundStyle(.white)
                    } // -> VStack
                    Spacer()
                    if sleepDuration != nil && completeSession {
                        let (stageHour,stageMin) = sleepDurationComponent(seconds: stageDuration!)
                        Text("\(stageHour)H \(stageMin)M")
                            .foregroundStyle(.white)
                    } else {
                        Text("--")
                            .foregroundStyle(.white)
                    }
                } // -> HStack
                .foregroundStyle(.white)
                .padding(.bottom, 15)
                  
            } // ForEach
            
        } // -> VStack
        .preferredColorScheme(.dark)
        .onAppear {
            fetchSleepSessions(date: selectedDate)
        }
        
    } // -> body
    
    func currentDayLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    } // -> currentDayLabel
    
    func fetchSleepSessions(date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = #Predicate<SleepSession> {
            $0.day >= startOfDay && $0.day < endOfDay
        }

        let descriptor = FetchDescriptor<SleepSession>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.day)]
        )

        do {
            currSession = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch sessions: \(error)")
        }
    } // -> fetchSleepSessions
    
    func colorForSleep(efficiency: Double?, isCompleted: Bool) -> Color {
        guard let data = efficiency, isCompleted else {
            return .grayNA
        } // -> guard let data = efficiency
        if data >= 80 {
            return .accent
        } else if data >= 70 {
            return .yelloWarning
        } else {
            return .redWarning
        } // -> if data
    }

    func sleepDurationComponent(seconds: TimeInterval) -> (Int,Int) {
        let hours = Int(seconds) / 3600
        let mins = (Int(seconds) % 3600) / 60
        return (hours, mins)
    } // -> averageSleepHours
    
    func fixedCurrentDate() -> Date {
        let now = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let hour = calendar.component(.hour, from: now)
        // If it's before 6 AM, subtract one day
        if hour < 6 {
            return calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        } else {
            return startOfToday
        } // -> if hour < 6
    } // -> fixedCurrentDate()
    
} // -> DayAnalysis

#Preview {
    DaySummary()
} // -> Preview
