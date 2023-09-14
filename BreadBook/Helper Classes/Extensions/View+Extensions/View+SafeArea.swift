//
//  View+SafeArea.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

extension View {
    
    var safeAreaBottomInset: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    func tapOn(point: CGPoint) {
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map {$0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
        }
        
    }
    
}
