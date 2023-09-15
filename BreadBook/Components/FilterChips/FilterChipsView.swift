//
//  FilterChipsView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct FilterChipsView: View {
    
    typealias State = FilterStateProtocol
    
    var state: State
    var isSelected: Bool
    var text: String
    private let onTap: (() -> Void)
    
    init(
        state: State,
        isSelected: Bool = false,
        text: String,
        onTap: @escaping (() -> Void)
    ) {
        self.state = state
        self.isSelected = isSelected
        self.text = text
        self.onTap = onTap
    }
    
    var body: some View {
        
        Button {
            onTap()
        } label: {
            Text(text)
                .font(state.font)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .foregroundColor(state.foregroundColor)
        }
        .background(state.color)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.clear, lineWidth: 1)
        )
    }
}

struct FilterChipsView_Previews: PreviewProvider {
    static var previews: some View {
        FilterChipsView(state: FilterState.selected,
                        isSelected: true,
                        text: "All") {
            
        }
    }
}
