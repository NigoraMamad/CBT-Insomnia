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
        requestHealthAuthorization { _ in }
    } // -> init
    
    // MARK: REQUEST AUTHORIZATION
    func requestHealthAuthorization(completion: @escaping (Bool) -> Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            completion(false)
            return
        } // guard
        
        let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let healthTypes: Set<HKObjectType> = [sleepAnalysis]
        
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { (success, error) in
            
            DispatchQueue.main.async {
                if success {
                    self.authorization = true
                    completion(success)
                } else {
                    print("HealthKit authorization failed: \(error?.localizedDescription ?? "No error found")")
                    completion(false)
                } // -> if-else
            }
        } // -> healthStore
        
    } // -> requestHealthAuthorization
    
    // MARK: MAP SLEEP STAGES
    func mapToSleepStage(from value: Int) -> SleepStages {
        switch value {
            case HKCategoryValueSleepAnalysis.awake.rawValue: return .awake
            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue: return .asleepUnspecified
            case HKCategoryValueSleepAnalysis.asleepCore.rawValue: return .asleepCore
            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue: return .asleepDeep
            case HKCategoryValueSleepAnalysis.asleepREM.rawValue: return .asleepREM
            default: return .asleepUnspecified
        } // -> value
    } // -> mapToSleepStage
    
    // MARK: TO TEST PREV DATA (ONLY WITH USERS THAT SLEEPS FROM 12 AM)
    func fetchAllSleep(modelContext: ModelContext) {
        if self.authorization == false { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let endDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: endDate, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            
            guard let samples = samples as? [HKCategorySample], error == nil else {
                print("error fetching sleep analysis data: \(String(describing: error))")
                return
            } // -> samples
            
            let calendar = Calendar.current
            
            let groupedByDay = Dictionary(grouping: samples) { sample in
                calendar.startOfDay(for: sample.startDate)
            } // -> groupDates
            
            DispatchQueue.main.async {
                
                for (day, samplesForDay) in groupedByDay {
                    
                    var sleepDuration: TimeInterval = 0
                    var stageDurations: [SleepStages: TimeInterval] = [:]
                    
                    for sample in samplesForDay {
                        let duration = sample.endDate.timeIntervalSince(sample.startDate)
                        guard duration > 0 else { continue }
                        let stage = self.mapToSleepStage(from: sample.value)
                        stageDurations[stage, default: 0] += duration
                        if stage != .awake {
                            sleepDuration += duration
                        } // -> if stage != .awake
                    } // -> for sample in samplesForDay
                    
                    let stageDurationModel = stageDurations.map {
                        SleepStageDuration(stage: $0.key, duration: $0.value)
                    } // -> stageDurationModel
                    
                    let earliest = samplesForDay.map(\.startDate).min()!
                    let latest = samplesForDay.map(\.endDate).max()!
                    
                    let bedtimeOffset = TimeInterval(Int.random(in: 15 * 60 ... 2 * 60 * 60)) // 15 min to 2h before
                    let wakeupOffset = TimeInterval(Int.random(in: 15 * 60 ... 2 * 60 * 60)) // 15 min to 3h after
                    
                    let badgeBedTime = earliest.addingTimeInterval(-bedtimeOffset)
                    let badgeWakeUpTime = latest.addingTimeInterval(wakeupOffset)
                    
                    let session = SleepSession(
                        day: day,
                        badgeWakeUpTime: badgeWakeUpTime,
                        badgeBedTime: badgeBedTime,
                        sleepDuration: sleepDuration,
                        stageDurations: stageDurationModel
                    ) // -> session
                    
                    modelContext.insert(session)
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("Failed to save: \(error)")
                    } // -> do-catch
                    
                } // -> for (day, samplesForDay) in groupedByDay
                
            } // -> DispatchQueue
            
        } // -> query
        
        healthStore.execute(query)
    } // -> fetchAllSleep
    
    // MARK: FETCH CURRENT SLEEP BADGE IN AND OUT
    func fetchSleep(
        modelContext: ModelContext,
        session: SleepSession,
        badgeOut: Date
    ) {
        if self.authorization == false { return }
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let badgeIn = session.badgeBedTime
        let predicate = HKQuery.predicateForSamples(withStart: badgeIn, end: badgeOut, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    print("Error fetching sleep analysis data: \(String(describing: error))")
                    return
                } // -> samples
            
                DispatchQueue.main.async {
                    
                    var sleepDuration: TimeInterval = 0
                    var stageDurations: [SleepStages: TimeInterval] = [:]
                    
                    for sample in samples {
                        // Skip out-of-bounds samples (just in case)
                        if sample.endDate <= badgeIn || sample.startDate >= badgeOut {
                            continue
                        } // -> if
                        
                        // Clip to badge interval
                        let clippedStart = max(sample.startDate, badgeIn)
                        let clippedEnd = min(sample.endDate, badgeOut)
                        let duration = clippedEnd.timeIntervalSince(clippedStart)
                        guard duration > 0 else { continue }
                        
                        let stage = self.mapToSleepStage(from: sample.value)
                        stageDurations[stage, default: 0] += duration
                        if stage != .awake {
                            sleepDuration += duration
                        } // -> if
                    } // -> for sample in samplesForDay
                    
                    let stageDurationModel = stageDurations.map {
                        SleepStageDuration(stage: $0.key, duration: $0.value)
                    } // -> stageDurationModel
                    
                    // Update the provided session
                    session.badgeWakeUpTime = badgeOut
                    session.sleepDuration = sleepDuration
                    session.stageDurations = stageDurationModel
                    session.updateCalculatedProperties()
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("Failed to save updated session: \(error)")
                    } // -> do-catch
                    
                } // -> DispatchQueue
            
            } // -> query
            
            healthStore.execute(query)
        
    } // -> fetchSleep
    
} // -> HealthManager
