//
//  SpinnerViewWithCheckMark.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct SpinnerViewWithCheckMark: View {
    
    // MARK: - Variables
    var color: Color
    
    // MARK: - Bindings
    @Binding var didFinishLoading: Bool
    
    var body: some View {
        ZStack {
            SpinnerView(configuration: SpinnerConfiguration(color: color, width: 20, height: 20, lineWidth: 2))
                .opacity(didFinishLoading ? 0 : 1)
            
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 22, height: 22, alignment: .center)
                .foregroundColor(color)
                .rotationEffect(.degrees(didFinishLoading ? 360 : 0))
                .opacity(didFinishLoading ? 1 : 0)
                .animation(Animation.easeInOut)
        }
    }
}

struct SpinnerViewWithCheckMark_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerViewWithCheckMark(color: .black, didFinishLoading: Binding<Bool>(get: {
            return false}, set: { _ in}))
    }
}
