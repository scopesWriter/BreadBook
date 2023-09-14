//
//  FilterState.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

enum FilterState: FilterStateProtocol {
    
    case `default`
    case selected
    
    var foregroundColor: Color {
        switch self {
        case .default:
            return .originalBlack
        case .selected:
            return .black
        }
    }
    
    var color: Color {
        switch self {
        case .default:
            return .neutral200
        case .selected:
            return .primary100
        }
    }
    
    var font: Font {
        switch self {
        case .default:
            return .caption3
        case .selected:
            return .caption1
        }
    }
    
}
