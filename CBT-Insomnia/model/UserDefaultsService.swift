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
    case half
    case one
    case oneHalf
    case two

    var dateComponents: DateComponents {
        switch self {
        case .half: return DateComponents(hour: 0, minute: 30)
        case .one: return DateComponents(hour: 1, minute: 0)
        case .oneHalf: return DateComponents(hour: 1, minute: 30)
        case .two: return DateComponents(hour: 2, minute: 0)
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
