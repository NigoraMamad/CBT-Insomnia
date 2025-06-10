//
//  HealthManager.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 20/05/25.
//

import Foundation
import HealthKit
import SwiftData

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    private var authorization = false
    
    init () {
        requestHealthAuthorization()
    } // -> init
    
    
    
    func requestHealthAuthorization() {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        } // guard
        
        let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let healthTypes: Set<HKObjectType> = [sleepAnalysis]
        
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { (success, error) in
            if success {
                self.authorization = true
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "No error found")")
            } // -> if-else
        } // -> healthStore
        
    } // -> requestHealthAuthorization
    
    
    
    func fetchSleep(
        modelContext: ModelContext,
        badgeIn: DateComponents,
        badgeOut: DateComponents
    ) {
        // Current day
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate current week
        let weekday = calendar.component(.weekday, from: now)
        print(weekday)
        let daysSinceMonday = (weekday + 5) % 7 // MODIFY LATER TO 5
        print(daysSinceMonday)
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceMonday-1, to: calendar.startOfDay(for: now))!
        print(startOfWeek)
        
        // Calculate missingDates
        let missingDates: [Date] = missingDates(daysSinceMonday: daysSinceMonday, startOfWeek: startOfWeek, modelContext: modelContext)
        fetchSleepHK(modelContext: modelContext, badgeIn: badgeIn, badgeOut: badgeOut, startOfWeek: startOfWeek, missingDates: missingDates)
            
    } // -> fetchSleep
    
    
    
    func missingDates(
        daysSinceMonday: Int,
        startOfWeek: Date,
        modelContext: ModelContext
    ) -> [Date] {
        // Current day
        let calendar = Calendar.current
        let now = Date()
        
        // Get all dates from Monday to Today
        let datesToCheck = (1...daysSinceMonday+1).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        } // -> datesToCheck
        print(datesToCheck)
        
        // Fetch existing SleepSessions
        let fetchDescriptor = FetchDescriptor<SleepSession>(
            predicate: #Predicate { session in
                session.day >= startOfWeek && session.day <= now
            } // -> predicate
        ) // -> fetchDescriptor
        
        // Calculate missingDates
        var missingDates: [Date] = []
        
        do {
            let existingSessions = try modelContext.fetch(fetchDescriptor)
            let existingDates = Set(existingSessions.map {
                calendar.startOfDay(for: $0.day)
            }) // -> existingDates

            // Compute missing dates
            missingDates = datesToCheck.filter { !existingDates.contains($0) }

            guard !missingDates.isEmpty else {
                print("All sleep sessions for this week already exist.")
                return []
            } // -> !missingDates.isEmpty
            
            print("existingSessions: \(existingSessions)")

        } catch {
            print("Failed to fetch existing sessions: \(error)")
            return datesToCheck
        } // -> do-catch
        
        return missingDates
    } // -> missingDates
    
    
    
    func fetchSleepHK(
        modelContext: ModelContext,
        badgeIn: DateComponents,
        badgeOut: DateComponents,
        startOfWeek: Date,
        missingDates: [Date]
    ) {
        // Current day
        let calendar = Calendar.current
        let now = Date()
        
        // Fetch all HealthKit sleep data of the missing dates
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let startDate = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: startOfWeek)! // Week start on Monday at 6:00 PM??? Talk with team and modify later???
        let endDate = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)! // Define today at 6:00 PM as the end
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKCategorySample] else {
                print("error fetching sleep analysis data: \(String(describing: error))")
                return
            } // -> samples
            
            let asleepSamples = samples.filter {
                $0.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue ||
                $0.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                $0.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                $0.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue
            }
            let grouped = Dictionary(grouping: asleepSamples) { sample in
                calendar.startOfDay(for: sample.startDate)
            } // -> grouped

            DispatchQueue.main.async {
                
                for date in missingDates {
                    guard let segments = grouped[date] else {
                        print("No HealthKit sleep data for \(date). Skipping.")
                        print()
                        continue
                    } // -> segments

                    let sleepDuration = segments.reduce(0.0) {
                        $0 + $1.endDate.timeIntervalSince($1.startDate)
                    } // -> sleepDuration
                    
                    var componentsBadgeIn = Calendar.current.dateComponents([.year, .month, .day], from: date)
                    componentsBadgeIn.hour = badgeIn.hour
                    componentsBadgeIn.minute = badgeIn.minute
                    componentsBadgeIn.second = badgeIn.second
                    
                    var componentsBadgeOut = Calendar.current.dateComponents([.year, .month, .day], from: date)
                    componentsBadgeOut.hour = badgeOut.hour
                    componentsBadgeOut.minute = badgeOut.minute
                    componentsBadgeOut.second = badgeOut.second

                    let newSession = SleepSession(
                        day: date,
                        badgeWakeUpTime: Calendar.current.date(from: componentsBadgeOut)!,
                        badgeBedTime: Calendar.current.date(from: componentsBadgeIn)!,
                        sleepDuration: sleepDuration
                    ) // -> session
                    
                    print(newSession)
                    
                    modelContext.insert(newSession)
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("Failed to save: \(error)")
                    } // -> do-catch
                    
                } // -> for missingDates

                print("Inserted missing sleep sessions.")
                
            } // -> DispatchQueue
            
        } // -> let
        
        healthStore.execute(query)
    } // -> fetchSleepHK
    
    
    func dateFor(date: Date) -> Days  {
        let componentDate = Calendar.current.dateComponents([.weekday], from: date)
        return Days.allCases.first(where: { $0.rawValue == componentDate.weekday }) ?? .mon
    } // -> dateFor
    
    func dayFor(day: Days, sessions: [SleepSession]) -> SleepSession? {
        sessions.first { session in
            let weekday = Calendar.current.component(.weekday, from: session.day)
            let weekdayEnum = Days.fromCalendarWeekday(calendarWeekday: weekday) // custom helper below
            return weekdayEnum == day
        }
    }
} // -> HealthManager
