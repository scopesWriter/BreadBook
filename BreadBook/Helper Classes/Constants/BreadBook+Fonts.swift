//
//  BreadBook+Fonts.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

enum BreadBookFontName: String{
    case bwModelica = "BwModelica"
    case ibmPlexSans = "IBMPlexSans"
}

enum BreadBookFontWeight: String {
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

struct BreadBookFont {
    static func createFont(name: BreadBookFontName = .bwModelica, weight: BreadBookFontWeight, size: CGFloat) -> Font {
        
        var fontName = "\(name.rawValue)-\(weight.rawValue.capitalizingFirstLetter())"
        return Font.custom(fontName, size: size)
    }
}

struct BreadBookUIFont {
    static func createFont(name: BreadBookFontName = .bwModelica, weight: BreadBookFontWeight, size: CGFloat) -> UIFont {
        UIFont(name: "\(name.rawValue)-\(weight.rawValue.capitalizingFirstLetter())", size: size) ?? .systemFont(ofSize: size)
    }
}
