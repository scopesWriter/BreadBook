//
//  ReactionCountViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Combine

class ReactionCountViewModel: ObservableObject, Identifiable {
    
    let id: Int
    @Published var count: Int
    @Published var isSelected: Bool
    let isIncremental: Bool
    let isTapDisabled: Bool
    let selectedImage: String
    let unselectedImage: String
    private let onTapAction: (_ isSelected: Bool) -> Void
    
    init(
        id: Int,
        count: Int,
        isSelected: Bool,
        isIncremental: Bool = true,
        isTapDisabled: Bool = false,
        selectedImage: String,
        unselectedImage: String,
        onTapAction: @escaping (_ isSelected: Bool) -> Void
    ) {
        self.id = id
        self.count = count
        self.isSelected = isSelected
        self.isIncremental = isIncremental
        self.isTapDisabled = isTapDisabled
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
        self.onTapAction = onTapAction
    }
    
    func toggle() {
        if isIncremental {
            count += isSelected ? -1 : 1
        }
        isSelected.toggle()
        onTapAction(isSelected)
    }
    
}
