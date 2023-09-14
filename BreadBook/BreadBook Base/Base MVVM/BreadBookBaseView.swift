//
//  BreadBookBaseView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct BreadBookBaseView<Content: View>: View {
    
    // MARK: - Properties
    let content: Content
    
    // MARK: - Init
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack {
                content.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
    
}

