//
//  LottieView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Lottie

enum LottieViewName: String {
    case splashScreen = "animation_lmjofvwu"
}

struct LottieView: UIViewRepresentable {
    var name: LottieViewName
    var loopMode: LottieLoopMode = .playOnce
    var completion: LottieCompletionBlock?
    
    var animationView = LottieAnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = LottieAnimation.named(name.rawValue)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play(completion: completion)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
