//
//  HealthManager.swift
//  testWatch
//
//  Created by Brenda Elena Saucedo Gonzalez on 20/05/25.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    
    @Published var activities: [String: Activity] = [:]
    
    let healthStore = HKHealthStore()
    
    init () {
        requestHealthAuthorization()
    } // -> init
    
    func requestHealthAuthorization() {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        } // guard
        
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        let healthTypes: Set<HKObjectType> = [steps, calories, sleepAnalysis]
        
        healthStore.requestAuthorization(toShare: [], read: healthTypes) { (success, error) in
            if success {
                self.fetchTodaySteps()
                self.fetchTodayCalories()
                self.fetchTodaySleep()
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "No error found")")
            } // -> if-else
        } // -> healthStore
        
    } // -> requestHealthAuthorization
    
    func fetchData() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, res, err in
            guard let result = res, let quantity = result.sumQuantity(), err == nil else {
                print("error fetching todays step data: \(String(describing: err))")
                return
            } // -> guard
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "\(stepCount)")
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
            } // -> DispatchQueue
        } // -> let
        healthStore.execute(query)
    } // -> fetchData
    
    func fetchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, res, err in
            guard let result = res, let quantity = result.sumQuantity(), err == nil else {
                print("error fetching todays step data: \(String(describing: err))")
                return
            } // -> guard
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "\(stepCount)")
            DispatchQueue.main.async {
                self.activities["todaySteps"] = activity
            } // -> DispatchQueue
        } // -> let
        healthStore.execute(query)
    } // -> fetchTodaySteps
    
    func fetchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, res, err in
            guard let result = res, let quantity = result.sumQuantity(), err == nil else {
                print("error fetching todays calories data: \(String(describing: err))")
                return
            } // -> guard
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today calories", subtitle: "Goal: 900", image: "flame", amount: "\(caloriesBurned)")
            DispatchQueue.main.async {
                self.activities["todayCalories"] = activity
            } // -> DispatchQueue
        } // -> let
        healthStore.execute(query)
    } // -> fetchTodayCalories
    
    func fetchTodaySleep() {
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
            } // -> guard
            print(samples)
        } // -> let
        healthStore.execute(query)
    } // -> fetchTodayCalories
    
} // -> HealthManager
