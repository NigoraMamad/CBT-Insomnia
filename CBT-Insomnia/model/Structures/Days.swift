//
//  Days.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import Foundation

enum Days: String, CaseIterable {
    case tue = "TUE"
    case wed = "WED"
    case thu = "THU"
    case fri = "FRI"
    case sat = "SAT"
    case sun = "SUN"
    case mon = "MON"
    
    var shortLabel: String {
        switch self {
            case .mon: return "M"
            case .tue, .thu: return "T"
            case .wed: return "W"
            case .fri: return "F"
            case .sat, .sun: return "S"
        } // -> switch
    } // -> shortLabel
    
    var weekday: Int {
        switch self {
            case .sun: return 1
            case .mon: return 2
            case .tue: return 3
            case .wed: return 4
            case .thu: return 5
            case .fri: return 6
            case .sat: return 7
        } // -> switch
    } // -> shortLabel
    
} // -> Period
