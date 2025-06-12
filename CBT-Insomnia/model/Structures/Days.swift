//
//  Days.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 31/05/25.
//

import Foundation

enum Days: Int, CaseIterable {
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
    case sun = 1
    
    var shortLabel: String {
        switch self {
            case .mon: return "M"
            case .tue, .thu: return "T"
            case .wed: return "W"
            case .fri: return "F"
            case .sat, .sun: return "S"
        } // -> switch
    } // -> shortLabel
    
    var longLabel: String {
        switch self {
            case .mon: return "MONDAY"
            case .tue: return "TUESDAY"
            case .wed: return "WEDNESDAY"
            case .thu: return "THURSDAY"
            case .fri: return "FRIDAY"
            case .sat: return "SATURDAY"
            case .sun: return "SUNDAY"
        } // -> switch
    } // -> longLabel
    
    static func fromCalendarWeekday(calendarWeekday: Int) -> Days? {
        return Days(rawValue: calendarWeekday)
    } // -> fromCalendarWeekday
    
} // -> Period
