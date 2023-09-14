//
//  OnReceive.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

extension View {
    func onReceive(_ name: String,
                   center: NotificationCenter = .default,
                   object: AnyObject? = nil,
                   perform action: @escaping (Notification) -> Void) -> some View {
        self.onReceive(
            center.publisher(for: Notification.Name(rawValue: name), object: object), perform: action
        )
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> some UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
