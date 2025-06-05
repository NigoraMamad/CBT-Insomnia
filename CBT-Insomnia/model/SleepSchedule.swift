//
//  SleepSchedule.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 05/06/25.
//
import Foundation
import SwiftData

@Model
class SleepSchedule {
    var id: UUID
    var weekStart: Date
    var bedTime: DateComponents
    var wakeUpTime: DateComponents
    var minEfficiencyGoal: Double

    @Relationship(deleteRule: .nullify, inverse: \SleepSession.schedule)
    var sleepSessions: [SleepSession] = []

    init(
        id: UUID = UUID(),
        weekStart: Date = Date(),
        bedTime: DateComponents,
        wakeUpTime: DateComponents,
        minEfficiencyGoal: Double = 90.0
    ) {
        self.id = id
        self.weekStart = weekStart
        self.bedTime = bedTime
        self.wakeUpTime = wakeUpTime
        self.minEfficiencyGoal = minEfficiencyGoal
    }
}


//let endOfWeek = Calendar.current.date(byAdding: .day, value: 7, to: schedule.weekStart)

