//
//  SleepStages.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 10/06/25.
//

import Foundation

enum SleepStages: String, CaseIterable {
    
    case awake = "Awake"
    case asleepREM = "Asleep (REM)"
    case asleepCore = "Asleep (Core)"
    case asleepDeep = "Asleep (Deep)"
    case asleepUnspecified = "Asleep (Unspecified)"
    
    var icon: String {
        switch self {
            case .awake: return "sun.max"
            case .asleepREM: return "sparkles"
            case .asleepCore: return "moon"
            case .asleepDeep: return "zzz"
            case .asleepUnspecified: return "bed.double"
        } // -> switch
    } // -> icon
    
} // -> SleepStages
