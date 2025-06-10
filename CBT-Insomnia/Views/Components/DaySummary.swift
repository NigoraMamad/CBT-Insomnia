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
    
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    
    @State private var currSession: [SleepSession] = []
    
    var body: some View {
        
        VStack {
            
            // MARK: STEPS TEXT
            HStack {
                Spacer()
                Button {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                    fetchSleepSessions(for: selectedDate)
                } label: {
                    Image(systemName: "chevron.backward")
                } // -> Button
                Spacer()
                Text(currentDayLabel(date: selectedDate))
                Spacer()
                Button {
                    if selectedDate < Calendar.current.startOfDay(for: Date()) {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                        fetchSleepSessions(for: selectedDate)
                    } // -> if selectedDate
                } label: {
                    Image(systemName: "chevron.forward")
                } // -> Button
                Spacer()
            } // -> HStack
            .foregroundStyle(.white)
            .padding(.bottom, 20)
            
             // MARK: PERCENT
            if let session = currSession.first {
                Text("\(String(format: "%.0f", session.sleepEfficiency))%")
                    .font(.dsDigital(.bold, size: 143))
                    .foregroundStyle(.accent)
                    .shadow(color: .accent.opacity(0.6), radius: 10, x: 0, y: 0)
                    .shadow(color: .accent.opacity(0.4), radius: 30, x: 0, y: 0)
                    .padding(.top, 10)
                Text("Efficiency")
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                // MARK: HOURS SLEPT VS GOAL SLEEP HOURS
                Text("Today you slept 6:20 out of 8 hours")
                    .foregroundStyle(.white)
                
                // MARK: PROGRESS BARR
                GeometryReader { geo in
                    let fullWidth = geo.size.width
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.tertiary)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 75 != 0.0 ? max(20, 0*fullWidth/100) : 0)
                    } // -> ZStack
                } // -> GeometryReader
                .frame(height: 20)
                .padding(.bottom, 30)
                
                Divider()
                    .frame(minHeight: 1)
                    .background(.white)
                    .padding(.bottom, 20)
            } // -> if !currSession.isEmpty
            
            // MARK: SLEEP INSIGHTS
            ForEach(0..<3) { _ in
                HStack {
                    Image(systemName: "bed.double.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 30, maxHeight: 20)
                        
                    VStack(alignment: .leading) {
                        Text("SLEEP DURATION")
                            .foregroundStyle(.accent)
                        Text("28/40")
                    }
                    Spacer()
                    Text("7:00")
                }
                .foregroundStyle(.white)
                .padding(.bottom, 30)
                  
            } // ForEach
            
        } // -> VStack
        .preferredColorScheme(.dark)
        .onAppear {
            fetchSleepSessions(for: selectedDate)
        }
        
    } // -> body
    
    func currentDayLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    } // -> currentDayLabel
    
    func fetchSleepSessions(for date: Date) {
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

    
} // -> DayAnalysis

#Preview {
    DaySummary()
} // -> Preview
