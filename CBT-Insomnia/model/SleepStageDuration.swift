//
//  SleepStageDuration.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 11/06/25.
//

import Foundation
import SwiftData

@Model
class SleepStageDuration {
    var stage: String
    var duration: TimeInterval
    
    init(stage: SleepStages, duration: TimeInterval) {
        self.stage = stage.rawValue
        self.duration = duration
    } // -> init
    
    var sleepStageEnum: SleepStages? {
        return SleepStages(rawValue: stage)
    } // -> sleepStageEnum
} // -> SleepStageDuration
