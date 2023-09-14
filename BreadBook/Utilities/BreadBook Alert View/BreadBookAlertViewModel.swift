//
//  BreadBookAlertViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import SwiftUI

struct BreadBookAlertViewModel {
    var hasClearBackground: Bool = false
    var title: String?
    var subtitle: String?
    var buttons: [BreadBookAlertViewButton]
    
}

struct BreadBookAlertViewButton: Identifiable {
    var id: String { title }
    var title: String
    var action: (() -> Void)
    var accessibilityId: String
    var isCancellableAction: Bool = false
    var backgroundColor: Color = Color.primary
    var foregroundColor: Color = Color.white
}
