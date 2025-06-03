//
//  SleepChallange.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 21/05/25.
//

import Foundation
import SwiftData

@Model
class SleepChallenge {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date

    var minEfficiencyGoal: Double


    // Relationship: one-to-many
    @Relationship(deleteRule: .nullify, inverse: \SleepSession.challenge)
    var sleepSessions: [SleepSession] = []
    // to calculate sleep average week efficency

    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        endDate: Date,
        minEfficiencyGoal: Double
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.minEfficiencyGoal = minEfficiencyGoal
    }
}
