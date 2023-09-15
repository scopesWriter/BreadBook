//
//  View+UUIDs.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 15/09/2023.
//

import SwiftUI

struct AddUUID: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content
                .id(UUID())
        } else {
            content
        }
    }
    
}

extension View {
    func addUUID() -> some View {
        return modifier(AddUUID())
    }
}
