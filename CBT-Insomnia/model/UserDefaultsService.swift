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
}

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let name = "setting_name"
        static let sleepDuration = "setting_sleepDuration"
        static let wakeUpTime = "setting_wakeUpTime"
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
}



func getBedTime() {
    guard
        let wakeUpTime = UserDefaultsService.shared.getWakeUpTime(),
        let sleepDuration = UserDefaultsService.shared.getSleepDuration()
    else {
        return
    }
    
    let wakeHour = wakeUpTime.hour ?? 7
    let wakeMinute = wakeUpTime.minute ?? 0
    let durationHour = sleepDuration.dateComponents.hour ?? 6
    let durationMinute = sleepDuration.dateComponents.minute ?? 0
    
    // 1. Convert wakeUpTime and sleepDuration to Date
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    
    let now = Date()
    var wakeComponents = calendar.dateComponents([.year, .month, .day], from: now)
    wakeComponents.hour = wakeHour
    wakeComponents.minute = wakeMinute
    
    guard let wakeDate = calendar.date(from: wakeComponents),
          let sleepDurationDate = calendar.date(from: DateComponents(hour: durationHour, minute: durationMinute))
    else { return }
    
    // 2. Subtract sleep duration
    let bedTimeDate = calendar.date(byAdding: .minute, value: -(durationHour * 60 + durationMinute), to: wakeDate)!
    
    // 3. Convert to DateComponents if needed
    let bedTimeComponents = calendar.dateComponents([.hour, .minute], from: bedTimeDate)
    
    print("Sleep time (bed time): \(bedTimeComponents.hour ?? 0):\(bedTimeComponents.minute ?? 0)")
    
}
