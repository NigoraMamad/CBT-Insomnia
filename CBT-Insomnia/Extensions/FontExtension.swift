//
//  FontExtension.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 01/06/25.
//

import SwiftUI

enum DsDigitalStyle: String {
    case regular = "DS-Digital"
    case bold = "DS-Digital-Bold"
}

enum Krungthep: String {
    case regular = "Krungthep"
}

extension Font {
    static func dsDigital(_ style: DsDigitalStyle, relativeTo textStyle: TextStyle) -> Font {
        return .custom(style.rawValue, size: UIFont.preferredFont(forTextStyle: textStyle.toUIFontTextStyle).pointSize, relativeTo: textStyle)
    }
    static func dsDigital(_ style: DsDigitalStyle, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    
    static func krungthep(_ style: Krungthep, relativeTo textStyle: TextStyle) -> Font {
        return .custom(style.rawValue, size: UIFont.preferredFont(forTextStyle: textStyle.toUIFontTextStyle).pointSize, relativeTo: textStyle)
    }
    static func krungthep(_ style: Krungthep, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
}

extension Font.TextStyle {
    var toUIFontTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }
}

