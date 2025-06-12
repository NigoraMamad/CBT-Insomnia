//
//  SettingModel.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 05/06/25.
//

import Foundation
import SwiftData


//Change to UserDefaults seperately
//@Model
//class SettingModel {
//    var name: String
//    var sleepDuration: SleepDuration //
//    var wakeUpTime: DateComponents
//
//    init(name: String, sleepDuration: SleepDuration, wakeUpTime: DateComponents) {
//        self.name = name
//        self.sleepDuration = sleepDuration
//        self.wakeUpTime = wakeUpTime
//    }
//}

enum SleepDuration: String, CaseIterable, Codable {
    case half, one, oneHalf, two, twoHalf, three, threeHalf, four, fourHalf,
         five, fiveHalf, six, sixHalf, seven, sevenHalf, eight, eightHalf,
         nine, nineHalf, ten, tenHalf, eleven, elevenHalf, twelve, twelveHalf,
         thirteen, thirteenHalf, fourteen, fourteenHalf, fifteen, fifteenHalf,
         sixteen, sixteenHalf, seventeen, seventeenHalf, eighteen, eighteenHalf,
         nineteen, nineteenHalf, twenty, twentyHalf, twentyOne, twentyOneHalf,
         twentyTwo, twentyTwoHalf, twentyThree, twentyThreeHalf, twentyFour
    
    var dateComponents: DateComponents {
        switch self {
        case .half: return DateComponents(hour: 0, minute: 30)
        case .one: return DateComponents(hour: 1)
        case .oneHalf: return DateComponents(hour: 1, minute: 30)
        case .two: return DateComponents(hour: 2)
        case .twoHalf: return DateComponents(hour: 2, minute: 30)
        case .three: return DateComponents(hour: 3)
        case .threeHalf: return DateComponents(hour: 3, minute: 30)
        case .four: return DateComponents(hour: 4)
        case .fourHalf: return DateComponents(hour: 4, minute: 30)
        case .five: return DateComponents(hour: 5)
        case .fiveHalf: return DateComponents(hour: 5, minute: 30)
        case .six: return DateComponents(hour: 6)
        case .sixHalf: return DateComponents(hour: 6, minute: 30)
        case .seven: return DateComponents(hour: 7)
        case .sevenHalf: return DateComponents(hour: 7, minute: 30)
        case .eight: return DateComponents(hour: 8)
        case .eightHalf: return DateComponents(hour: 8, minute: 30)
        case .nine: return DateComponents(hour: 9)
        case .nineHalf: return DateComponents(hour: 9, minute: 30)
        case .ten: return DateComponents(hour: 10)
        case .tenHalf: return DateComponents(hour: 10, minute: 30)
        case .eleven: return DateComponents(hour: 11)
        case .elevenHalf: return DateComponents(hour: 11, minute: 30)
        case .twelve: return DateComponents(hour: 12)
        case .twelveHalf: return DateComponents(hour: 12, minute: 30)
        case .thirteen: return DateComponents(hour: 13)
        case .thirteenHalf: return DateComponents(hour: 13, minute: 30)
        case .fourteen: return DateComponents(hour: 14)
        case .fourteenHalf: return DateComponents(hour: 14, minute: 30)
        case .fifteen: return DateComponents(hour: 15)
        case .fifteenHalf: return DateComponents(hour: 15, minute: 30)
        case .sixteen: return DateComponents(hour: 16)
        case .sixteenHalf: return DateComponents(hour: 16, minute: 30)
        case .seventeen: return DateComponents(hour: 17)
        case .seventeenHalf: return DateComponents(hour: 17, minute: 30)
        case .eighteen: return DateComponents(hour: 18)
        case .eighteenHalf: return DateComponents(hour: 18, minute: 30)
        case .nineteen: return DateComponents(hour: 19)
        case .nineteenHalf: return DateComponents(hour: 19, minute: 30)
        case .twenty: return DateComponents(hour: 20)
        case .twentyHalf: return DateComponents(hour: 20, minute: 30)
        case .twentyOne: return DateComponents(hour: 21)
        case .twentyOneHalf: return DateComponents(hour: 21, minute: 30)
        case .twentyTwo: return DateComponents(hour: 22)
        case .twentyTwoHalf: return DateComponents(hour: 22, minute: 30)
        case .twentyThree: return DateComponents(hour: 23)
        case .twentyThreeHalf: return DateComponents(hour: 23, minute: 30)
        case .twentyFour: return DateComponents(hour: 24)
        }
    }
    
    var timeInterval: TimeInterval {
        let components = self.dateComponents
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return TimeInterval(hours * 3600 + minutes * 60)
    }
}

import Foundation

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let lastEfficiencyPromptDate = "last_efficiency_prompt_date"
        static let name = "setting_name"
        static let sleepDuration = "setting_sleepDuration"
        static let wakeUpTime = "setting_wakeUpTime"
        static let bedTimeOffset = "bed_time_offset"
       /* static let wakeUpOffset = "wake_up_offset"*/ // ✅ Added key
    }
    
    // MARK: - Save Methods
    
    func saveName(_ name: String) {
        defaults.set(name, forKey: Keys.name)
    }
    
    func saveSleepDuration(_ duration: SleepDuration) {
        defaults.set(duration.rawValue, forKey: Keys.sleepDuration)
    }
    
    func saveWakeUpTime(_ components: DateComponents) {
        if let data = try? JSONEncoder().encode(components) {
            defaults.set(data, forKey: Keys.wakeUpTime)
            NotificationManager.shared.scheduleDailyNotifications()
        }
    }
    
    func saveBedTimeOffset(_ components: DateComponents) {
        if let data = try? JSONEncoder().encode(components) {
            defaults.set(data, forKey: Keys.bedTimeOffset)
        }
    }
    
    func saveWakeUpOffset(_ components: DateComponents) {
        if let data = try? JSONEncoder().encode(components) {
            defaults.set(data, forKey: Keys.wakeUpTime)
            
        }
    }
    
    // MARK: - Get Methods
    
    func getName() -> String? {
        defaults.string(forKey: Keys.name)
    }
    
    func getSleepDuration() -> SleepDuration? {
        if let raw = defaults.string(forKey: Keys.sleepDuration) {
            return SleepDuration(rawValue: raw)
        }
        return nil
    }
    
    func getWakeUpTime() -> DateComponents? {
        if let data = defaults.data(forKey: Keys.wakeUpTime),
           let components = try? JSONDecoder().decode(DateComponents.self, from: data) {
            return components
        }
        return nil
    }
    
    func getBedTimeOffset() -> DateComponents? {
        if let data = defaults.data(forKey: Keys.bedTimeOffset),
           let components = try? JSONDecoder().decode(DateComponents.self, from: data) {
            return components
        }
        return nil
    }

    func getWakeUpOffset() -> DateComponents? {
        if let data = defaults.data(forKey: Keys.wakeUpTime),
           let components = try? JSONDecoder().decode(DateComponents.self, from: data) {
            return components
        }
        return nil
    }
}


extension UserDefaultsService {
    
    func getLastPromptDate() -> Date? {
        defaults.object(forKey: Keys.lastEfficiencyPromptDate) as? Date
    }

    func setLastPromptDate(_ date: Date) {
        defaults.set(date, forKey: Keys.lastEfficiencyPromptDate)
    }

    func shouldShowEfficiencyPrompt() -> Bool {
        let calendar = Calendar.current
        guard let lastPrompt = getLastPromptDate(),
              let lastWeekStart = calendar.dateInterval(of: .weekOfYear, for: lastPrompt)?.start,
              let currentWeekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start
        else {
            return true
        }

        return currentWeekStart > lastWeekStart
    }

//    func adjustWakeTime(by minutes: Int) {
//        guard let wake = getWakeUpTime() else { return }
//        let calendar = Calendar.current
//        let date = calendar.date(from: wake) ?? Date()
//        let newDate = calendar.date(byAdding: .minute, value: minutes, to: date)!
//        let updated = calendar.dateComponents([.hour, .minute], from: newDate)
//        saveWakeUpTime(updated)
//    }
    
    func adjustWakeTime(by minutes: Int) {
        guard let wake = getWakeUpTime(),
              let duration = getSleepDuration()
        else { return }

        let calendar = Calendar.current

        // 1. Get the current wake-up time as Date
        let wakeHour = wake.hour ?? 7
        let wakeMinute = wake.minute ?? 0
        let wakeDate = calendar.date(from: DateComponents(hour: wakeHour, minute: wakeMinute)) ?? Date()

        // 2. Add minutes to wake-up time
        let newWakeDate = calendar.date(byAdding: .minute, value: minutes, to: wakeDate)!
        let newWakeComponents = calendar.dateComponents([.hour, .minute], from: newWakeDate)
        saveWakeUpTime(newWakeComponents)

        // 3. Increase sleep duration accordingly
        let currentMinutes = (duration.dateComponents.hour ?? 0) * 60 + (duration.dateComponents.minute ?? 0)
        let newDuration = durationFromMinutes(currentMinutes + minutes)
        saveSleepDuration(newDuration)
    }
    

    func adjustBedTime(by minutes: Int) {
        guard let wake = getWakeUpTime(),
              let duration = getSleepDuration()
        else { return }

        let wakeHour = wake.hour ?? 7
        let wakeMinute = wake.minute ?? 0
        let wakeDate = Calendar.current.date(from: DateComponents(hour: wakeHour, minute: wakeMinute)) ?? Date()

        let durationTime = duration.dateComponents
        let totalMinutes = (durationTime.hour ?? 0) * 60 + (durationTime.minute ?? 0) + minutes

        let updatedComponents = Calendar.current.dateComponents(
            [.hour, .minute],
            from: wakeDate.addingTimeInterval(-Double(totalMinutes * 60))
        )

        saveSleepDuration(durationFromMinutes(totalMinutes))
    }

    private func durationFromMinutes(_ minutes: Int) -> SleepDuration {
        let hour = minutes / 60
        let minute = minutes % 60

        return SleepDuration.allCases.first(where: {
            $0.dateComponents.hour == hour && $0.dateComponents.minute == minute
        }) ?? .eight
    }
}
