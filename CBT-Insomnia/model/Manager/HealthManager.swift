//
//  HealthManager.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 20/05/25.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    
    @Published var selectedMode: Period = .day
    @Published var sleepItems: [SleepItem] = []
    @Published var sleepEfficiencies: [SleepEfficiency] = []

    
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
    
    
    
    func fetchSleep() {
        
        //if !self.authorization { return }
        
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let calendar = Calendar.current
        let now = Date()
        
        let weekday = calendar.component(.weekday, from: now)
        
        // Calculate how many days have passed since Monday
        let daysSinceMonday = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceMonday, to: calendar.startOfDay(for: now))!
        
        // Week start on Monday at 6:00 PM??? Talk with team and modify later???
        let startDate = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: startOfWeek)!
        
        // Define today at 6:00 PM as the end
        let endDate = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKCategorySample] else {
                print("error fetching sleep analysis data: \(String(describing: error))")
                return
            } // -> guard
            
            DispatchQueue.main.async {
                self.sleepItems = samples.compactMap { sample in
                    var stage: SleepStage {
                        switch sample.value {
                            case HKCategoryValueSleepAnalysis.awake.rawValue: .awake
                            case HKCategoryValueSleepAnalysis.asleepREM.rawValue: .rem
                            case HKCategoryValueSleepAnalysis.asleepCore.rawValue: .core
                            case HKCategoryValueSleepAnalysis.asleepDeep.rawValue: .deep
                            case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue: .asleep
                            default: .unknown
                        } // -> switch
                    } // -> sleepStage
                    let sleepItem = SleepItem(sleepStage: stage, startDate: sample.startDate, endDate: sample.endDate)
                    print(sleepItem)
                    print("Start: \(sleepItem.startDate.formatted(date: .abbreviated, time: .shortened))")
                    print("End: \(sleepItem.endDate.formatted(date: .abbreviated, time: .shortened))")
                    print()
                    return sleepItem
                } // -> sleepItems
            } // -> DispatchQueue
            
        } // -> let
        healthStore.execute(query)
            
    } // -> fetchSleep
    
    
    
    func calculateSleepEfficiency() {
        
        //if !self.authorization { return }
        
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let calendar = Calendar.current
        let now = Date()
        
        let weekday = calendar.component(.weekday, from: now)
        
        // Calculate how many days have passed since Monday
        let daysSinceMonday = (weekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceMonday, to: calendar.startOfDay(for: now))!
        
        // Week start on Monday at 6:00 PM??? Talk with team and modify later???
        let startDate = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: startOfWeek)!
        
        // Define today at 6:00 PM as the end
        let endDate = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKCategorySample] else {
                print("error fetching sleep analysis data: \(String(describing: error))")
                return
            } // -> guard
            
            // Group by day
            let groupedByDay = Dictionary(grouping: samples) { sample -> Date in
                let bedtimeReference = sample.startDate
                return calendar.startOfDay(for: bedtimeReference)
            } // -> groupedByDay
            
            let maxGap: TimeInterval = 60 * 60  // 1 hour
            
            var sleepBlocks: [(start: Date, end: Date, asleepDuration: TimeInterval)] = []
            
            // NO IN BED PARAMETER
            for (date, dailySamples) in groupedByDay {
                var currentStart: Date?
                var currentEnd: Date?
                var currentAsleep: TimeInterval = 0
                
                for (index, sample) in dailySamples.enumerated() {
                    
                    let stage = sample.value
                    let isAsleep = [
                        HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue,
                        HKCategoryValueSleepAnalysis.asleepCore.rawValue,
                        HKCategoryValueSleepAnalysis.asleepDeep.rawValue,
                        HKCategoryValueSleepAnalysis.asleepREM.rawValue
                    ].contains(stage)
                    
                    // Start new sleep block
                    if currentStart == nil {
                        currentStart = sample.startDate
                        currentEnd = sample.endDate
                        currentAsleep = isAsleep ? sample.endDate.timeIntervalSince(sample.startDate) : 0
                        continue
                    } // -> if
                    
                    let previousEnd = currentEnd!
                    let currentGap = sample.startDate.timeIntervalSince(previousEnd)
                    
                    if currentGap > maxGap {
                        // Save current block
                        sleepBlocks.append((start: currentStart!, end: currentEnd!, asleepDuration: currentAsleep))
                        // Start new block
                        currentStart = sample.startDate
                        currentEnd = sample.endDate
                        currentAsleep = isAsleep ? sample.endDate.timeIntervalSince(sample.startDate) : 0
                    } else {
                        // Continue block
                        currentEnd = max(currentEnd!, sample.endDate)
                        if isAsleep {
                            currentAsleep += sample.endDate.timeIntervalSince(sample.startDate)
                        }
                    } // -> if-else
                    
                    // Final block
                    if let start = currentStart, let end = currentEnd {
                        sleepBlocks.append((start: start, end: end, asleepDuration: currentAsleep))
                    } // -> if
                    
                } // -> for in samples
                
            } // -> for in groupedByDay
            
            DispatchQueue.main.async {
                self.sleepEfficiencies = []
                for block in sleepBlocks {
                    let summary = SleepEfficiency(
                        date: calendar.startOfDay(for: block.start),
                        inBedDuration: block.end.timeIntervalSince(block.start),
                        asleepDuration: block.asleepDuration
                    ) // -> summary
                    self.sleepEfficiencies.append(summary)
                } // -> for in sleepBlocks
            } // -> DispatchQueue
            
        } // -> let
        healthStore.execute(query)
        
    } // ->  calculateSleepEfficiency
    
    
    
    func dateFor(day: Days) -> Date? {
        let calendar = Calendar.current
        let today = Date()
        
        guard let index = Days.allCases.firstIndex(of: day) else { return nil }
        
        let todayWeekday = calendar.component(.weekday, from: today)
        let daysSinceMonday = (todayWeekday + 5) % 7
        let startOfWeek = calendar.date(byAdding: .day, value: -daysSinceMonday, to: calendar.startOfDay(for: today))!

        return calendar.date(byAdding: .day, value: index, to: startOfWeek)
    } // -> dateFor
    
} // -> HealthManager



struct SleepItem: Identifiable {
    let id: UUID = UUID()
    let sleepStage: SleepStage
    let startDate: Date
    let endDate: Date
}

enum SleepStage: String {
    case awake = "awake"
    case rem = "REM"
    case core = "Core"
    case deep = "Deep"
    case asleep = "Unspecified"
    case unknown = "Unknown"
}

struct SleepEfficiency: Identifiable {
    let id = UUID()
    let date: Date
    let inBedDuration: TimeInterval
    let asleepDuration: TimeInterval
    var efficiency: Double {
        guard inBedDuration > 0 else { return 0 }
        return (asleepDuration / inBedDuration) * 100
    } // -> efficiency
} // -> SleepSummary



/*
class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    private var authorization = false
    
    init () {
        requestHealthAuthorization()
    } // -> init
    
    func requestHealthAuthorization() {
        // ...
    } // -> requestHealthAuthorization
    
    func fetchSleep() {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let calendar = Calendar.current
        let now = Date()
        
        let startOfPreviousNight = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now.addingTimeInterval(-86400))!
        let endOfPreviousNight = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfPreviousNight, end: endOfPreviousNight, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKCategorySample] else {
                print("error fetching sleep analysis data: \(String(describing: error))")
                return
            } // -> guard|
            print(samples)
        } // -> let
        healthStore.execute(query)
    } // -> fetchTodayCalories
    
} // -> HealthManager
*/

















/*
 @ -16,39 +16,58 @@ extension Date {

 class HealthManager: ObservableObject {
     
     // To get and use health data/parameters
     @Published var activities: [String: Activity] = [:]
     
     // Instance for HealthStore
     let healthStore = HKHealthStore()
     
     init () {
         requestHealthAuthorization()
         requestAuthorization()
     } // -> init
     
     func requestHealthAuthorization() {
     
     
     func requestAuthorization() {
         
         // Check if HealthKit is available on current device
         guard HKHealthStore.isHealthDataAvailable() else {
             print("HealthKit is not available on this device.")
             return
         } // guard
         
         let steps = HKQuantityType(.stepCount)
         let calories = HKQuantityType(.activeEnergyBurned)
         let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
         // Get identifier data type from HealthKit
         guard
             let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
             let calories = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
             let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
         else {
             return
         }
         
         // Gather all health types needed
         let healthTypes: Set<HKObjectType> = [steps, calories, sleepAnalysis]
         
         // Request authorization
         healthStore.requestAuthorization(toShare: [], read: healthTypes) { (success, error) in
             if success {
                 // If success -> fetch data
                 self.fetchTodaySteps()
                 self.fetchTodayCalories()
                 self.fetchTodaySleep()
                 self.fetchTodaySleep { sample in
                     self.interpretSleepSamples(samples: sample)
                 }
                 //self.recordSleep()
             } else {
                 // Else -> print error
                 print("HealthKit authorization failed: \(error?.localizedDescription ?? "No error found")")
             } // -> if-else
         } // -> healthStore
         
     } // -> requestHealthAuthorization
     
     
     
     func fetchData() {
         let steps = HKQuantityType(.stepCount)
         let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
 @ -66,6 +85,8 @@ class HealthManager: ObservableObject {
         healthStore.execute(query)
     } // -> fetchData
     
     
     
     func fetchTodaySteps() {
         let steps = HKQuantityType(.stepCount)
         let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
 @ -83,6 +104,8 @@ class HealthManager: ObservableObject {
         healthStore.execute(query)
     } // -> fetchTodaySteps
     
     
     
     func fetchTodayCalories() {
         let calories = HKQuantityType(.activeEnergyBurned)
         let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
 @ -100,25 +123,186 @@ class HealthManager: ObservableObject {
         healthStore.execute(query)
     } // -> fetchTodayCalories
     
     func fetchTodaySleep() {
         let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
     
     
     func fetchTodaySleep(completion: @escaping ([HKCategorySample]) -> Void) {
         
         // Get sleep analysis data type from HealthKit
         guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
             completion([])
             return
         }
         
         //let calendar = Calendar.current
         //let now = Date()
         
         //let startOfPreviousNight = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now.addingTimeInterval(-86400))!
         //let endOfPreviousNight = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
         
         //let predicate = HKQuery.predicateForSamples(withStart: startOfPreviousNight, end: endOfPreviousNight, options: .strictStartDate)
         
         let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
         let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
         
         let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
         
         let query = HKSampleQuery(
             sampleType: sleepType,
             predicate: predicate,
             limit: HKObjectQueryNoLimit,
             sortDescriptors: [sortDescriptor]
         ) { (query, samples, error) in
             guard let samples = samples as? [HKCategorySample] else {
                 completion([])
                 print("error fetching sleep analysis data: \(String(describing: error))")
                 return
             } // -> guard
             completion(samples)
         } // -> let
         healthStore.execute(query)
     } // -> fetchTodayCalories
     
     
     
     
     
     func fetchSleepLastNight(
         preferredSleepStart: DateComponents,
         preferredWakeUp: DateComponents,
         completion: @escaping ([HKCategorySample]) -> Void
     ) {
         // Get sleep analysis data type from HealthKit
         guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
             completion([])
             return
         }
         
         let calendar = Calendar.current
         let now = Date()
         guard let yesterday = calendar.date(byAdding: .day, value: -1, to: now) else {
             return
         }
         
         let startOfPreviousNight = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: now.addingTimeInterval(-86400))!
         let endOfPreviousNight = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: now)!
         // Calculate the start and end of the previous night
         var sleepStartComponents = preferredSleepStart
         sleepStartComponents.day = calendar.component(.day, from: yesterday)
         sleepStartComponents.month = calendar.component(.month, from: yesterday)
         sleepStartComponents.year = calendar.component(.year, from: yesterday)
         
         let predicate = HKQuery.predicateForSamples(withStart: startOfPreviousNight, end: endOfPreviousNight, options: .strictStartDate)
         var wakeUpComponents = preferredWakeUp
         wakeUpComponents.day = calendar.component(.day, from: now)
         wakeUpComponents.month = calendar.component(.month, from: now)
         wakeUpComponents.year = calendar.component(.year, from: now)
         
         let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
             guard let samples = samples as? [HKCategorySample] else {
         guard
             let sleepStart = calendar.date(from: sleepStartComponents),
             let wakeUp = calendar.date(from: wakeUpComponents)
         else {
             return
         }
         
         let predicate = HKQuery.predicateForSamples(withStart: sleepStart, end: wakeUp, options: .strictStartDate)
         
         let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
         
         let query = HKSampleQuery(
             sampleType: sleepType,
             predicate: predicate,
             limit: HKObjectQueryNoLimit,
             sortDescriptors: [sortDescriptor]
         ) { (query, samples, error) in
             guard
                 let samples = samples as? [HKCategorySample],
                 error == nil
             else {
                 completion([])
                 print("error fetching sleep analysis data: \(String(describing: error))")
                 return
             } // -> guard
             print(samples)
             completion(samples)
         } // -> let
         healthStore.execute(query)
     } // -> fetchTodayCalories
     
     func interpretSleepSamples(samples: [HKCategorySample]) {
         
         for sample in samples {
             
             // Timeframe
             let start = sample.startDate
             let end = sample.endDate

             // Tag the type of sleep stage
             var sleepStage: String {
                 switch sample.value {
                 case HKCategoryValueSleepAnalysis.inBed.rawValue: "In Bed"
                 case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue: "Unspecified"
                 case HKCategoryValueSleepAnalysis.awake.rawValue: "Awake"
                 case HKCategoryValueSleepAnalysis.asleepREM.rawValue: "REM"
                 case HKCategoryValueSleepAnalysis.asleepCore.rawValue: "Core"
                 case HKCategoryValueSleepAnalysis.asleepDeep.rawValue: "Deep"
                 default: "Unknown"
                 } // -> switch
             } // -> sleepStage

             print("Stage: \(sleepStage), from: \(formatDateRange(start: start, end: end))")
             
         } // -> for
         
     } // -> interpretSleepSamples
     
     
     
     
     func recordSleep() {
         let now = Date()
         let startBed = Calendar.current.date(byAdding: .hour, value: -8, to: now)
         let startSleep = Calendar.current.date(byAdding: .minute, value: -470, to: now)
         let endSleep = Calendar.current.date(byAdding: .minute, value: -5, to: now)
         
         let sleepType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)
         let inBed = HKCategorySample.init(type: sleepType!, value: HKCategoryValueSleepAnalysis.inBed.rawValue, start: startBed!, end: now)
         let asleep = HKCategorySample.init(type: sleepType!, value: HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue, start: startSleep!, end: endSleep!)
         healthStore.save([inBed, asleep]) { (success, error) in
             if success {
                 print(inBed)
                 print(asleep)
                 print("Saved")
             } else {
                 print()
                 print(error)
                 print()
             }
         }
     }
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     

     
 } // -> HealthManager



 func formatDateRange(start: Date, end: Date) -> String {
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale.current
     dateFormatter.dateFormat = "MMM d, yyyy - h:mm a"

     let startString = dateFormatter.string(from: start)
     let endString = dateFormatter.string(from: end)

     return "\(startString) to \(endString)"
 }
 */
