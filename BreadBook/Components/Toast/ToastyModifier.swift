//
//  ToastyModifier.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import PopupView

struct ToastyModifier: ViewModifier {
    
    @State private var isShowing: Bool = false
    @State private var shouldShowRetry: Bool = false
    @State private var shouldHide: Bool = true
    @State private var viewModel: ToastyViewModel = .default
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isShowing) {
                ToastyView(viewModel: $viewModel, isShowing: $isShowing, shouldShowRetry: $shouldShowRetry)
                    .padding(20)
                    .padding(.bottom, content.safeAreaBottomInset + (shouldShowRetry ? 90 : 40))
                
            } customize: {
                return $0
                    .type(.toast)
                    .position(.bottom)
                    .dragToDismiss(false)
                    .closeOnTap(true)
                    .autohideIn(shouldHide ? 5 : .infinity)
            }
            .onReceive(Constants.toasty) { notification in
                if let viewModel = notification.userInfo?[Constants.toastyViewModel] as? ToastyViewModel {
                    self.viewModel = viewModel
                    self.isShowing = true
                    self.shouldShowRetry = viewModel.shouldShowRetry
                    self.shouldHide = viewModel.shouldHide
                }
            }
    }
    
}

extension View {
    func hasToasty() -> some View {
        modifier(ToastyModifier())
    }
}
