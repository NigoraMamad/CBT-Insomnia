//
//  SettingModel.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 05/06/25.
//

import Foundation
import SwiftData

@Model
class SettingModel {
    var name: String
    var sleepDuration: DateComponents
    var wakeUpTime: DateComponents
    
    init(name: String, sleepDuration: DateComponents, wakeUpTime: DateComponents) {
        self.name = name
        self.sleepDuration = sleepDuration
        self.wakeUpTime = wakeUpTime
    }
}
