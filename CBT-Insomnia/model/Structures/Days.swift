//
//  Days.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import Foundation

enum Days: String, CaseIterable {
    case mon = "MON"
    case tue = "TUE"
    case wed = "WED"
    case thu = "THU"
    case fri = "FRI"
    case sat = "SAT"
    case sun = "SUN"
    
    var shortLabel: String {
        switch self {
            case .mon: return "M"
            case .tue, .thu: return "T"
            case .wed: return "W"
            case .fri: return "F"
            case .sat, .sun: return "S"
        } // -> switch
    } // -> shortLabel
    
} // -> Period
