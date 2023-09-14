//
//  FeedFilterViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

struct FeedFilterViewModel: Identifiable {
 
    let id: Int
    var state: FilterState
    var isSelected: Bool
    let text: String
    let onTap: (() -> Void)
    
    init(
        id: Int,
        state: FilterState = .default,
        isSelected: Bool = false,
        text: String,
        onTap: @escaping (() -> Void)
    ) {
        self.id = id
        self.state = state
        self.isSelected = isSelected
        self.text = text
        self.onTap = onTap
    }
    
}

extension FeedFilterViewModel: Hashable {
    static func == (lhs: FeedFilterViewModel, rhs: FeedFilterViewModel) -> Bool {
        lhs.id == rhs.id && lhs.isSelected == rhs.isSelected && lhs.state == rhs.state
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
