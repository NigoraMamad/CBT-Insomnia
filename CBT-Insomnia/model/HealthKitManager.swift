//
//  HealthKitManager.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 04/06/25.
//

import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    private init() {} 

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        healthStore.requestAuthorization(toShare: [], read: [sleepType]) { success, error in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    func fetchSleepDuration(from startDate: Date, to endDate: Date, completion: @escaping (TimeInterval) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            var totalDuration: TimeInterval = 0

            if let samples = samples as? [HKCategorySample] {
                for sample in samples where
                    sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue ||
                    sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue {
                        totalDuration += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }

            DispatchQueue.main.async {
                completion(totalDuration)
            }
        }
        
        healthStore.execute(query)
    }
}
