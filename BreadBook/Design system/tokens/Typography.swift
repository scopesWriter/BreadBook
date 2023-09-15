//
//  Typography.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

extension Font {
    
    static let button1 = font(style: .button1)
    static let button2 = font(style: .button2)
    static let button3 = font(style: .button3)
    static let caption1 = font(style: .caption1)
    static let caption2 = font(style: .caption2)
    static let caption3 = font(style: .caption3)
    static let body4 = font(style: .body4)
    static let body5 = font(style: .body5)
    static let body6 = font(style: .body6)
    
    private static func font(family: TypographyFontFamily = .BwModelica, style: TypographyStyle) -> Font {
        let fontName = "\(family.rawValue)-\(style.weight.rawValue.capitalizingFirstLetter())"
        return Font.custom(fontName, size: style.size)
    }
    
}

extension UIFont {
    
    static let heading1 = font(style: .heading1)
    static let heading2 = font(style: .heading2)
    static let subtitle1 = font(style: .subtitle1)
    static let subtitle2 = font(style: .subtitle2)
    static let body1 = font(style: .body1)
    static let body2 = font(style: .body2)
    static let body3 = font(style: .body3)
    static let buttonAllCaps = font(style: .buttonAllCaps)
    static let button1 = font(style: .button1)
    static let button2 = font(style: .button2)
    static let button3 = font(style: .button3)
    static let caption1 = font(style: .caption1)
    static let caption2 = font(style: .caption2)
    static let caption3 = font(style: .caption3)
    static let body4 = font(style: .body4)
    static let body5 = font(style: .body5)
    static let body6 = font(style: .body6)
    
    private static func font(family: TypographyFontFamily = .BwModelica, style: TypographyStyle) -> UIFont {
        let fontName = "\(family.rawValue)-\(style.weight.rawValue.capitalizingFirstLetter())"
        return UIFont(name: fontName, size: style.size) ?? .systemFont(ofSize: style.size)
    }
    
}

// MARK: - Font Family
enum TypographyFontFamily: String {
    case BwModelica
    case IBMPlexSans
}

// MARK: - Font Weight
enum TypographyFontWeight: String {
    case black
    case blackItalic
    case bold
    case boldItalic
    case extraBold
    case extraBoldItalic
    case hairline
    case hairlineItalic
    case medium
    case mediumItalic
    case regular
    case regularItalic
    case thin
    case thinItalic
    case semiBold
}

// MARK: Style
enum TypographyStyle {
    case heading1
    case heading2
    case subtitle1
    case subtitle2
    case body1
    case body2
    case body3
    case buttonAllCaps
    case button1
    case button2
    case button3
    case caption1
    case caption2
    case caption3
    case body4
    case body5
    case body6
    
    var weight: TypographyFontWeight {
        switch self {
        case .heading1:
            return .bold
        case .heading2:
            return .medium
        case .subtitle1:
            return .bold
        case .subtitle2:
            return .bold
        case .body1:
            return .bold
        case .body2:
            return .medium
        case .body3:
            return .regular
        case .buttonAllCaps:
            return .bold
        case .button1:
            return .bold
        case .button2:
            return .medium
        case .button3:
            return .regular
        case .caption1:
            return .bold
        case .caption2:
            return .medium
        case .caption3:
            return .regular
        case .body4:
            return .regular
        case .body5:
            return .medium
        case .body6:
            return .bold
        }
    }
    
    var size: CGFloat {
        switch self {
        case .heading1:
            return 24
        case .heading2:
            return 20
        case .subtitle1:
            return 16
        case .subtitle2:
            return 14
        case .body1:
            return 14
        case .body2:
            return 14
        case .body3:
            return 14
        case .buttonAllCaps:
            return 14
        case .button1:
            return 14
        case .button2:
            return 14
        case .button3:
            return 12
        case .caption1:
            return 12
        case .caption2:
            return 12
        case .caption3:
            return 12
        case .body4:
            return 10
        case .body5:
            return 10
        case .body6:
            return 10
        }
    }
}
