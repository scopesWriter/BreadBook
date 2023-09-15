//
//  AlertView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import SwiftUI

struct AlertView: View {
    // MARK: - Variables
    var viewModel: BreadBookAlertViewModel
    var axis: Axis
    
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer().frame(height: 35)
            if let title = viewModel.title {
                Text(title)
                    .font(BreadBookFont.createFont(weight: .bold, size: 14))
                
            }
            Spacer().frame(height: 15)
            if let subtitle = viewModel.subtitle {
                HStack {
                    Spacer().frame(width: 35)
                    Text(subtitle)
                        .font(BreadBookFont.createFont(weight: .regular, size: 12))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                    Spacer().frame(width: 35)
                    
                }
                
            }
            Spacer().frame(height: 30)
            if !viewModel.buttons.isEmpty {
                switch axis {
                case .horizontal:
                    HStack(spacing: 10) {
                        createAlertButtons(buttons: viewModel.buttons)
                    }
                    .padding([.horizontal], viewModel.buttons.count == 1 ? 55 : 28)
                    .padding(.bottom, 35)
                case .vertical:
                    VStack(spacing: 12) {
                        createAlertButtons(buttons: viewModel.buttons)
                    }
                    .padding([.horizontal], viewModel.buttons.count == 1 ? 55 : 28)
                    .padding(.bottom, 35)
                }
            }
            
        }
        .background(Color.background)
        .cornerRadius(30)
        .clipped()
        .padding(.horizontal, 20)
    }
    
    private func createAlertButtons(buttons: [BreadBookAlertViewButton]) -> some View {
        ForEach(viewModel.buttons) { button in
            Button(action: button.action) {
                Text(button.title)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(BreadBookFont.createFont(weight: .bold, size: 14))
            }
            .frame(height: 50)
            .foregroundColor(button.isCancellableAction ? Color.black : button.foregroundColor)
            .background(button.isCancellableAction ? Color.neutral200 : button.backgroundColor)
            .clipShape(Capsule())
            .accessibility(identifier: button.accessibilityId)
        }
    }
}

// MARK: - Preview
struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        let buttons: [BreadBookAlertViewButton] = [BreadBookAlertViewButton(title: "OK", action: {
            print("BreadBook Error")
        }, accessibilityId: ""),
                                                   BreadBookAlertViewButton(title: "OK", action: {
            print("BreadBook Error")
        }, accessibilityId: "", isCancellableAction: false),
                                                   
        ]
        let alertViewModel = BreadBookAlertViewModel(
            title: "New UPDATE AVAILABLE!",
            subtitle: "Update now to the latest version of BreadBook and be fond of the new features and experience enhancements.",
            buttons: buttons)
        
        AlertView(viewModel: alertViewModel, axis: .horizontal)
            .previewLayout(.sizeThatFits)
    }
}
