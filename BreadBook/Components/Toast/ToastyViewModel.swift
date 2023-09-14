//
//  ToastyViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

struct ToastyViewModel: Identifiable {
    let id = UUID()
    let type: ToastyType
    let title: String
    var shouldHide: Bool
    var shouldShowRetry: Bool = false
    let action: () -> Void
    
    enum ToastyType {
        case normal
        case error
        case success
    }
}

extension ToastyViewModel {
    static let `default`: Self = ToastyViewModel(type: .normal, title: "", shouldHide: true, action: { })
}
