//
//  BaseViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

@available(iOS, deprecated: 14.5, message: "Extend from Observable Object and remove the extension from children view models.")
class BaseViewModel {
    @Published var shouldDisable = false
    @Published var isLoading: Bool = true
    @Published var monitor = NetworkMonitor()
    @Published var networkConnectionError = false
    @Published var retrierHandler: (() -> Void)?
    @Published var errorType: ErrorViewType = .noError
    @Published var showToast: Bool?
    @Published var toastMsg: String?
    
    func handleError() {
        if !monitor.isConnected {
            errorType = .connectionError
        } else {
            errorType = .technicalError
        }
    }
    
    func handleShowErrorToast(error: Error, action: (() -> Void)? = nil) {
        toastMsg = error.localizedDescription
        retrierHandler = action
        showToast = true
    }
}

extension BaseViewModel {
    
    func hideToast() {
        showToast = false
    }
}
