//
//  ToastyView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

import SwiftUI

struct ToastyView: View {
    
    @Binding var viewModel: ToastyViewModel
    @Binding var isShowing: Bool
    @Binding var shouldShowRetry: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image(viewModel.type.imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
            
            Text(viewModel.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(BreadBookFont.createFont(weight: .medium, size: 10))
                .onTapGesture {
                    isShowing = false
                    viewModel.action()
                }
            
            Spacer(minLength: 15)
            
            HStack {
                if shouldShowRetry {
                    Button("Retry") {
                        isShowing = false
                        viewModel.action()
                    }
                    .foregroundColor(.white)
                    .font(BreadBookFont.createFont(weight: .bold, size: 10))
                    .frame(width: 30)
                }
                
                Image(Icon.close.rawValue)
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 12, height: 12)
                    .onTapGesture {
                        isShowing = false
                    }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(viewModel.type.backgroundColor)
        .cornerRadius(Style.CornerRadius.card)
    }
}

extension ToastyViewModel.ToastyType {
    var imageName: String {
        switch self {
        case .normal, .error:
            return Icon.alert.rawValue
        case .success:
            return Icon.success.rawValue
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .normal:
            return Color.primary
        case .error:
            return Color.error
        case .success:
            return Color.success
        }
    }
}

struct ToastyView_Previews: PreviewProvider {
    static var previews: some View {
        ToastyView(
            viewModel: .constant(.init(
                type: .normal,
                title: "Start Your Day Right with Breadfast",
                shouldHide: true,
                action: { })
            ),
            isShowing: .constant(true),
            shouldShowRetry: .constant(false)
        )
        .previewLayout(.sizeThatFits)
    }
}
